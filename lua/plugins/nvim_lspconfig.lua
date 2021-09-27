local lspconfig = require 'lspconfig'
local fn = vim.fn
local highlight = vim.highlight

lspconfig.gopls.setup{
  flags = {
    debounce_text_changes = 500,
  },
  settings = {
    gopls = {
      directoryFilters = {'-plz-out'},
    },
  },
}
lspconfig.pyright.setup{}

-- Use icons in theme colour for error / warning signs
fn.sign_define('LspDiagnosticsSignError', {text = '', texthl = 'LspDiagnosticsError'})
fn.sign_define('LspDiagnosticsSignWarning', {text = '', texthl = 'LspDiagnosticsWarning'})

-- LspDiagnosticsError and LspDiagnosticsWarning are linked to theme groups so link default groups to them as well
highlight.link('LspDiagnosticsDefaultError', 'LspDiagnosticsError', true)
highlight.link('LspDiagnosticsDefaultWarning', 'LspDiagnosticsWarning', true)
