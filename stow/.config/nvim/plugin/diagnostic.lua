vim.diagnostic.config({
  virtual_text = {
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '󰌵',
    },
  },
  float = {
    source = true,
  },
  severity_sort = true,
})

vim.keymap.set('n', 'yoe', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  print((vim.diagnostic.is_enabled() and 'Enabled' or 'Disabled') .. ' diagnostics')
end, { desc = 'Toggle diagnostics' })
