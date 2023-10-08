local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  return
end
local util = require('lspconfig.util')
local configs = require('lspconfig.configs')
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

mason.setup()
mason_lspconfig.setup({
  automatic_installation = true,
})

local augroup = vim.api.nvim_create_augroup('lspconfig_config', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.codeLensProvider then
      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost', 'CursorHold' }, {
        callback = vim.lsp.codelens.refresh,
        group = augroup,
        buffer = args.buf,
        desc = 'Refresh codelenses automatically in this buffer',
      })
    end
  end,
  group = augroup,
})

configs.please = {
  default_config = {
    cmd = { 'plz', 'tool', 'lps' },
    filetypes = { 'please' },
    root_dir = util.root_pattern('.plzconfig'),
  },
}

lspconfig.bashls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

lspconfig.clangd.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

lspconfig.cmake.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

lspconfig.gopls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  settings = {
    gopls = {
      directoryFilters = { '-plz-out' },
      linksInHover = false,
      usePlaceholders = false,
      semanticTokens = true,
      codelenses = {
        gc_details = true,
      },
    },
  },
  root_dir = function(fname)
    local gowork_or_gomod_dir = util.root_pattern('go.work')(fname) or util.root_pattern('go.mod')(fname)
    if gowork_or_gomod_dir then
      return gowork_or_gomod_dir
    end

    local plzconfig_dir = util.root_pattern('.plzconfig')(fname)
    if plzconfig_dir and vim.fs.basename(plzconfig_dir) == 'src' then
      vim.env.GOPATH = string.format('%s:%s/plz-out/go', vim.fs.dirname(plzconfig_dir), plzconfig_dir)
      vim.env.GO111MODULE = 'off'
    end

    return vim.fn.getcwd()
  end,
})

lspconfig.golangci_lint_ls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_new_config = function(config)
    -- https://golangci-lint.run/usage/linters/#enabled-by-default
    local linters = { 'errcheck', 'gosimple', 'govet', 'ineffassign', 'staticcheck', 'unused' }
    for _, linter in ipairs(linters) do
      table.insert(config.init_options.command, '--enable')
      table.insert(config.init_options.command, linter)
    end
  end,
})

lspconfig.intelephense.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

lspconfig.java_language_server.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

lspconfig.jsonls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

lspconfig.marksman.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

lspconfig.please.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

lspconfig.pylsp.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  settings = {
    pylsp = {
      plugins = {
        autopep8 = { enabled = false },
        flake8 = { enabled = true },
        mccabe = { enabled = false },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        yapf = { enabled = false },
        jedi_completion = { enabled = true },
      },
    },
  },
  on_new_config = function(config, root_dir)
    local plzconfig_dir = util.root_pattern('.plzconfig')(root_dir)
    if not plzconfig_dir then
      return
    end
    config.settings.pylsp.plugins.jedi = {
      extra_paths = {
        plzconfig_dir,
        vim.fs.joinpath(plzconfig_dir, 'plz-out/gen'),
      },
    }
  end,
})

require('neodev').setup({
  override = function(_, library)
    library.enabled = true
  end,
})

lspconfig.lua_ls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = function(_, bufnr)
    vim.bo[bufnr].formatexpr = ''
  end,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
      completion = {
        keywordSnippet = 'Disable',
      },
      diagnostics = {
        disable = {
          'redefined-local',
        },
      },
      format = {
        enable = false,
      },
    },
  },
})

lspconfig.tsserver.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  root_dir = function()
    return vim.fn.getcwd()
  end,
})

lspconfig.vimls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

lspconfig.yamlls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  settings = {
    yaml = {
      validate = false,
    },
  },
})

local virtual_text_float_config = {
  source = true,
  ---@param diagnostic Diagnostic
  ---@return string
  format = function(diagnostic)
    local source_prefix = string.format('%s: ', diagnostic.source)
    local message = diagnostic.message:gsub('^' .. source_prefix, '')
    return message
  end,
}
vim.diagnostic.config({
  float = virtual_text_float_config,
  virtual_text = virtual_text_float_config,
  source = true,
  severity_sort = true,
})

vim.lsp.set_log_level(vim.log.levels.OFF)

vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticHint' })

vim.keymap.set('n', 'dK', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next({ wrap = false })
end)
vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev({ wrap = false })
end)
vim.keymap.set('n', '<leader>dd', function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    print('Enabled diagnostics')
  else
    vim.diagnostic.disable()
    print('Disabled diagnostics')
  end
end)
vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run)
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN }, wrap = false })
end)
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN }, wrap = false })
end)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>fm', function()
  vim.lsp.buf.format({ timeout_ms = 5000 })
end)
