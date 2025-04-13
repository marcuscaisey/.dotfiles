local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  return
end
local util = require('lspconfig.util')
local ok, blink = pcall(require, 'blink.cmp')
if not ok then
  return
end
local ok, mason = pcall(require, 'mason')
if not ok then
  return
end
local ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not ok then
  return
end
local ok, neodev = pcall(require, 'neodev')
if not ok then
  return
end

local augroup = vim.api.nvim_create_augroup('lspconfig', { clear = true })

mason.setup()
mason_lspconfig.setup({
  automatic_installation = true,
})

util.default_config = vim.tbl_deep_extend('force', util.default_config, {
  capabilities = blink.get_lsp_capabilities(),
})

if vim.env.NVIM_ENABLE_LSP_DEVTOOLS == 'true' then
  util.default_config.on_new_config = function(config)
    config.cmd = { 'lsp-devtools', 'agent', '--', unpack(config.cmd) }
  end
end

lspconfig.clangd.setup({
  cmd = { 'clangd', '--offset-encoding=utf-16' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' }, -- Default excluding proto
})

---@param plz_root string
---@return string? goroot
---@return string? errmsg
local function plz_goroot(plz_root)
  local gotool_res = vim.system({ 'plz', '--repo_root', plz_root, 'query', 'config', 'plugin.go.gotool' }):wait()
  local gotool = 'go'
  if gotool_res.code == 0 then
    gotool = vim.trim(gotool_res.stdout)
  elseif not gotool_res.stderr:match('Settable field not defined') then
    return nil, string.format('querying value of plugin.go.gotool: %s', gotool_res.stderr)
  end

  if vim.startswith(gotool, ':') or vim.startswith(gotool, '//') then
    gotool = gotool:gsub('|go$', '')
    local gotool_output_res = vim.system({ 'plz', '--repo_root', plz_root, 'query', 'output', gotool }):wait()
    if gotool_output_res.code > 0 then
      return nil, string.format('querying output of plugin.go.gotool target %s: %s', gotool, gotool_output_res.stderr)
    end
    return vim.fs.joinpath(plz_root, vim.trim(gotool_output_res.stdout))
  end

  if vim.startswith(gotool, '/') then
    if not vim.uv.fs_stat(gotool) then
      return nil, string.format('plugin.go.gotool %s does not exist', gotool)
    end
    local goroot_res = vim.system({ gotool, 'env', 'GOROOT' }):wait()
    if goroot_res.code == 0 then
      return vim.trim(goroot_res.stdout)
    else
      return nil, string.format('%s env GOROOT: %s', gotool, goroot_res.stderr)
    end
  end

  local build_paths_res = vim.system({ 'plz', '--repo_root', plz_root, 'query', 'config', 'build.path' }):wait()
  if build_paths_res.code > 0 then
    return nil, string.format('querying value of build.path: %s', build_paths_res.stderr)
  end
  local build_paths = vim.trim(build_paths_res.stdout)
  for build_path in vim.gsplit(build_paths, '\n') do
    for build_path_part in vim.gsplit(build_path, ':') do
      local go = vim.fs.joinpath(build_path_part, gotool)
      if vim.uv.fs_stat(go) then
        local goroot_res = vim.system({ go, 'env', 'GOROOT' }):wait()
        if goroot_res.code == 0 then
          return vim.trim(goroot_res.stdout)
        else
          return nil, string.format('%s env GOROOT: %s', go, goroot_res.stderr)
        end
      end
    end
  end

  return nil, string.format('plugin.go.gotool %s not found in build.path %s', gotool, build_paths:gsub('\n', ':'))
end

lspconfig.gopls.setup({
  settings = {
    gopls = {
      directoryFilters = { '-plz-out' },
      semanticTokens = true,
      semanticTokenTypes = {
        string = false,
      },
      codelenses = {
        gc_details = true,
      },
    },
  },
  ---@param client vim.lsp.Client
  ---@param bufnr integer
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      desc = 'Run gopls source.organizeImports code action',
      callback = function()
        local params = vim.lsp.util.make_range_params(0, client.offset_encoding) ---@type lsp.CodeActionParams
        params.context = { only = { 'source.organizeImports' }, diagnostics = {} }
        ---@type {err: lsp.ResponseError?, result:(lsp.CodeAction|lsp.Command)[]?}?
        local resp = client:request_sync(vim.lsp.protocol.Methods.textDocument_codeAction, params, nil, bufnr)
        if not resp or not resp.result then
          return
        end
        for _, code_action in pairs(resp.result) do
          if code_action.edit then
            vim.lsp.util.apply_workspace_edit(code_action.edit, client.offset_encoding)
          end
        end
      end,
    })
  end,
  root_dir = function(fname)
    local plz_root = vim.fs.root(fname, '.plzconfig')
    if plz_root and vim.fs.basename(plz_root) == 'src' then
      vim.env.GOPATH = string.format('%s:%s/plz-out/go', vim.fs.dirname(plz_root), plz_root)
      vim.env.GO111MODULE = 'off'
      local goroot, err = plz_goroot(plz_root)
      if not goroot then
        vim.notify(string.format('Determining GOROOT for plz repo %s: %s', plz_root, err), vim.log.levels.WARN)
      elseif not vim.uv.fs_stat(goroot) then
        vim.notify(string.format('GOROOT for plz repo %s does not exist: %s', plz_root, goroot), vim.log.levels.WARN)
      else
        vim.env.GOROOT = goroot
      end
      return vim.fn.getcwd()
    end

    local gowork_or_gomod_dir = vim.fs.root(fname, { 'go.work', 'go.mod' })
    if gowork_or_gomod_dir then
      return gowork_or_gomod_dir
    end

    return vim.fn.getcwd()
  end,
})

lspconfig.jdtls.setup({
  settings = {
    java = {
      referencesCodeLens = {
        enabled = false,
      },
    },
  },
})

neodev.setup({
  override = function(root_dir, library)
    if vim.uv.fs_stat(vim.fs.joinpath(root_dir, '.luarc.json')) then
      library.enabled = false
    end
  end,
})

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      diagnostics = {
        disable = {
          'redefined-local',
        },
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
})

lspconfig.ts_ls.setup({
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
})

vim.keymap.set('n', '<Leader>rl', '<Cmd>LspRestart<CR>')
