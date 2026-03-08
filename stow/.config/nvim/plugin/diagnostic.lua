local signs = {
  [vim.diagnostic.severity.ERROR] = ' ',
  [vim.diagnostic.severity.WARN] = ' ',
  [vim.diagnostic.severity.INFO] = ' ',
  [vim.diagnostic.severity.HINT] = '󰌵 ',
}
vim.diagnostic.config({
  virtual_text = { source = true },
  signs = { text = signs },
  status = { text = signs },
  float = { source = true },
  severity_sort = true,
})

vim.keymap.set('n', 'yoe', '<Cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>')
