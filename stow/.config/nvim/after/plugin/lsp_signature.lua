local ok, lsp_signature = pcall(require, 'lsp_signature')
if not ok then
  return
end
lsp_signature.setup({
  bind = true,
  handler_opts = {
    border = 'none',
  },
  hint_enable = false,
})
