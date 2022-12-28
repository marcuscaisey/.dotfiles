local lsp_signature = require('lsp_signature')

lsp_signature.setup({
  bind = true,
  handler_opts = {
    border = 'none',
  },
  hint_enable = false,
})
