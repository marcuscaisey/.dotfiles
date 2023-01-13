local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local util = require('lspconfig.util')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local telescope_builtin = require('telescope.builtin')
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
  automatic_installation = true,
})

local on_attach = function(client, bufnr)
  client.server_capabilities.semanticTokensProvider = nil

  vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
  vim.keymap.set('n', '<c-s>', telescope_builtin.lsp_document_symbols, { buffer = bufnr })
  vim.keymap.set('n', '<leader>s', telescope_builtin.lsp_dynamic_workspace_symbols, { buffer = bufnr })
  vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions, { buffer = bufnr })
  vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations, { buffer = bufnr })
  vim.keymap.set('n', 'ge', telescope_builtin.lsp_references, { buffer = bufnr })
  vim.keymap.set('n', 'dK', vim.diagnostic.open_float, { buffer = bufnr })
  vim.keymap.set('n', 'dr', vim.diagnostic.reset, { buffer = bufnr })
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr })
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { buffer = bufnr })
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { buffer = bufnr })
  vim.keymap.set('n', '<leader>rc', vim.lsp.codelens.run, { buffer = bufnr })
  vim.keymap.set('n', ']e', function()
    vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN } })
  end, { buffer = bufnr })
  vim.keymap.set('n', '[e', function()
    vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN } })
  end, { buffer = bufnr })
  vim.keymap.set('n', '<leader>dq', function()
    local diagnostics = vim.diagnostic.get(0)
    if #diagnostics == 0 then
      print('No diagnostics')
      vim.cmd.cclose()
      return
    end
    local qf_items = vim.diagnostic.toqflist(diagnostics)
    vim.fn.setqflist(qf_items)
    vim.cmd.copen()
    vim.cmd.cfirst()
  end, { buffer = bufnr })
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
  vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
end

configs.please = {
  default_config = {
    cmd = { 'plz', 'tool', 'lps' },
    filetypes = { 'please' },
    root_dir = util.root_pattern('.plzconfig'),
  },
}

lspconfig.bashls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = on_attach,
})

lspconfig.ccls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = on_attach,
  root_dir = function()
    return vim.fn.getcwd()
  end,
})

lspconfig.gopls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  settings = {
    gopls = {
      directoryFilters = { '-plz-out' },
      linksInHover = false,
      analyses = {
        unusedparams = true,
      },
      codelenses = {
        gc_details = true,
      },
      staticcheck = true,
    },
  },
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost', 'CursorHold' }, {
      callback = vim.lsp.codelens.refresh,
      group = vim.api.nvim_create_augroup('gopls', { clear = true }),
      buffer = bufnr,
      desc = 'Refresh codelenses when gopls is running',
    })
    on_attach(nil, bufnr)
  end,
  root_dir = function(fname)
    local go_mod_root = util.root_pattern('go.mod')(fname)
    if go_mod_root then
      return go_mod_root
    end
    local plz_root = util.root_pattern('.plzconfig')(fname)
    local gopath_root = util.root_pattern('src')(fname)
    if plz_root and gopath_root then
      vim.env.GOPATH = string.format('%s:%s/plz-out/go', gopath_root, plz_root)
      vim.env.GO111MODULE = 'off'
    end
    return vim.fn.getcwd()
  end,
})

lspconfig.intelephense.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = on_attach,
})

lspconfig.java_language_server.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = on_attach,
  cmd = { 'java_language_server.sh' },
})

lspconfig.jsonls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = on_attach,
})

lspconfig.marksman.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = on_attach,
})

lspconfig.please.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = on_attach,
})

lspconfig.pyright.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = on_attach,
  root_dir = function()
    return vim.fn.getcwd()
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'workspace',
        useLibraryCodeForTypes = true,
        typeCheckingMode = 'off',
        extraPaths = {
          '/home/mcaisey/core3/src',
          '/home/mcaisey/core3/src/plz-out/gen',
        },
      },
    },
  },
})

lspconfig.sumneko_lua.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
      completion = {
        keywordSnippet = 'Disable',
      },
    },
  },
})

lspconfig.tsserver.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = on_attach,
  root_dir = function()
    return vim.fn.getcwd()
  end,
})

lspconfig.vimls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = on_attach,
})

lspconfig.yamlls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = on_attach,
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
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticHint' })
