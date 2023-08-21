local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local telescope_builtin = require('telescope.builtin')
local mason_lspconfig = require('mason-lspconfig')
local mason = require('mason')

mason.setup()
mason_lspconfig.setup({
  automatic_installation = true,
})

configs.please = {
  default_config = {
    cmd = { 'plz', 'tool', 'lps' },
    filetypes = { 'please' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('.plzconfig', { upward = true, path = vim.fs.dirname(fname) })[1])
    end,
  },
}

lspconfig.bashls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

lspconfig.ccls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  root_dir = function()
    return vim.fn.getcwd()
  end,
})

lspconfig.cmake.setup({})

-- Bodge to silence the 'No code actions available' message which gets logged when I run the source.organizeImports code
-- action on save in a Go file and the imports are already organised.
local notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg == 'No code actions available' then
    return
  end
  notify(msg, level, opts)
end

local gopls_group = vim.api.nvim_create_augroup('gopls', { clear = true })
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
  on_attach = function(_, bufnr)
    vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost', 'CursorHold' }, {
      callback = vim.lsp.codelens.refresh,
      group = gopls_group,
      buffer = bufnr,
      desc = 'Refresh codelenses when gopls is running',
    })
    vim.api.nvim_create_autocmd('BufWritePre', {
      callback = function()
        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
      end,
      group = gopls_group,
      buffer = bufnr,
      desc = 'Organize imports before saving',
    })
  end,
  root_dir = function(fname)
    local go_mod = vim.fs.find('go.mod', { upward = true, path = vim.fs.dirname(fname) })[1]
    if go_mod then
      return vim.fs.dirname(go_mod)
    end

    -- Set GOPATH if we're in a directory called 'src' containing a .plzconfig
    local plzconfig_path = vim.fs.find('.plzconfig', { upward = true, path = vim.fs.dirname(fname) })[1]
    if plzconfig_path then
      local plzconfig_dir = vim.fs.dirname(plzconfig_path)
      if plzconfig_dir and vim.fs.basename(plzconfig_dir) == 'src' then
        vim.env.GOPATH = string.format('%s:%s/plz-out/go', vim.fs.dirname(plzconfig_dir), plzconfig_dir)
      end
    end

    return vim.fn.getcwd()
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
        pyflakes = { enabled = false },
        mccabe = { enabled = false },
        pycodestyle = { enabled = false },
        autopep8 = { enabled = false },
        flake8 = { enabled = true },
      },
    },
  },
})

require('neodev').setup({
  override = function(_, library)
    library.plugins = true
  end,
})

lspconfig.lua_ls.setup({
  capabilities = cmp_nvim_lsp.default_capabilities(),
  on_attach = function(_, bufnr)
    -- This gets set automatically by nvim which breaks formatting with gq.
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

vim.keymap.set('n', '<c-s>', telescope_builtin.lsp_document_symbols)
vim.keymap.set('n', '<leader>ss', telescope_builtin.lsp_dynamic_workspace_symbols)
vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions)
vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations)
vim.keymap.set('n', 'gr', function()
  telescope_builtin.lsp_references({
    jump_type = 'never',
  })
end)
vim.keymap.set('n', 'dK', vim.diagnostic.open_float)
vim.keymap.set('n', 'dr', vim.diagnostic.reset)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>rc', vim.lsp.codelens.run)
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN } })
end)
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN } })
end)
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setqflist)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>fm', function()
  vim.lsp.buf.format({ timeout_ms = 5000 })
end)
