local lspconfig = require('lspconfig')
local util = require('lspconfig.util')
local configs = require('lspconfig.configs')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local mason_lspconfig = require('mason-lspconfig')
local mason = require('mason')

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

lspconfig.cmake.setup({})

lspconfig.gopls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  settings = {
    gopls = {
      directoryFilters = { '-plz-out' },
      linksInHover = false,
      analyses = {
        unusedparams = true,
      },
      usePlaceholders = false,
      semanticTokens = true,
      codelenses = {
        gc_details = true,
      },
      staticcheck = true,
    },
  },
  root_dir = function(fname)
    local go_work_dir = util.root_pattern('go.work')(fname)
    if go_work_dir then
      return go_work_dir
    end

    local go_mod_dir = util.root_pattern('go.mod')(fname)
    if go_mod_dir then
      return go_mod_dir
    end

    -- Set GOPATH if we're in a directory called 'src' containing a .plzconfig
    local plzconfig_dir = util.root_pattern('.plzconfig')(fname)
    if plzconfig_dir and vim.fs.basename(plzconfig_dir) == 'src' then
      vim.env.GOPATH = string.format('%s:%s/plz-out/go', vim.fs.dirname(plzconfig_dir), plzconfig_dir)
    end

    return vim.fn.getcwd()
  end,
})

lspconfig.golangci_lint_ls.setup({
  root_dir = util.root_pattern(
    '.golangci.yml',
    '.golangci.yaml',
    '.golangci.toml',
    '.golangci.json',
    'go.work',
    'go.mod'
  ),
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
      },
    },
  },
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

vim.diagnostic.config({
  float = {
    source = 'always',
  },
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
