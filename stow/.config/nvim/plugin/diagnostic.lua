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

vim.keymap.set('n', '<Leader>dd', function()
  if not vim.diagnostic.is_enabled() then
    vim.diagnostic.enable()
    print('Enabled diagnostics')
  else
    vim.diagnostic.enable(false)
    print('Disabled diagnostics')
  end
end, { desc = 'Toggle diagnostics' })
