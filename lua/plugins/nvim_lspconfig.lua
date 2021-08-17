local lspconfig = require 'lspconfig'

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
