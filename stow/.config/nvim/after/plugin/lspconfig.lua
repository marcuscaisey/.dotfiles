local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  return
end
local configs = require('lspconfig.configs')
local util = require('lspconfig.util')
local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
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
local protocol = require('vim.lsp.protocol')

mason.setup()
mason_lspconfig.setup({
  automatic_installation = true,
})

util.default_config = vim.tbl_deep_extend('force', util.default_config, {
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

configs.please = {
  default_config = {
    cmd = { 'plz', 'tool', 'lps' },
    filetypes = { 'please' },
    root_dir = util.root_pattern('.plzconfig'),
  },
}

lspconfig.bashls.setup({})

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

if vim.env.NVIM_DISABLE_GOLANGCI_LINT ~= 'true' then
  lspconfig.golangci_lint_ls.setup({})
end

lspconfig.gopls.setup({
  settings = {
    gopls = {
      directoryFilters = { '-plz-out' },
      linksInHover = false,
      usePlaceholders = false,
      semanticTokens = true,
      noSemanticString = true,
      codelenses = {
        gc_details = true,
      },
    },
  },
  root_dir = function(fname)
    local gowork_or_gomod_dir = util.root_pattern('go.work', 'go.mod')(fname)
    if gowork_or_gomod_dir then
      return gowork_or_gomod_dir
    end

    local plz_root = util.root_pattern('.plzconfig')(fname)
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

lspconfig.jsonls.setup({})

lspconfig.marksman.setup({})

lspconfig.please.setup({})

lspconfig.pyright.setup({
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
      },
    },
  },
  on_new_config = function(config, root_dir)
    if util.root_pattern('.plzconfig') then
      config.settings = vim.tbl_deep_extend('force', config.settings, {
        python = {
          analysis = {
            extraPaths = {
              vim.fs.joinpath(root_dir, 'plz-out/python/venv'),
            },
            exclude = { 'plz-out' },
          },
        },
      })
    end
  end,
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
      diagnostics = {
        disable = {
          'redefined-local',
        },
      },
      format = {
        enable = false,
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
})

lspconfig.rust_analyzer.setup({
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = false,
      },
    },
  },
})

lspconfig.tsserver.setup({
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
  handlers = {
    [protocol.Methods.textDocument_publishDiagnostics] = function(_, result, ctx, config)
      if result.diagnostics ~= nil then
        local idx = 1
        while idx <= #result.diagnostics do
          if result.diagnostics[idx].code == 80001 then
            table.remove(result.diagnostics, idx)
          else
            idx = idx + 1
          end
        end
      end
      vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
    end,
  },
})

lspconfig.vimls.setup({})
