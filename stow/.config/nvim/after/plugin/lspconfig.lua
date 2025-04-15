local util = require('lspconfig.util')
local ok, blink = pcall(require, 'blink.cmp')
if not ok then
  return
end


util.default_config = vim.tbl_deep_extend('force', util.default_config, {
  capabilities = blink.get_lsp_capabilities(),
})

vim.keymap.set('n', '<Leader>rl', '<Cmd>LspRestart<CR>')
