local virtual_text_float_config = {
  source = true,
  ---@param diagnostic vim.Diagnostic
  ---@return string
  format = function(diagnostic)
    local source_prefix = string.format('%s: ', diagnostic.source)
    local message = diagnostic.message:gsub('^' .. source_prefix, '')
    return message
  end,
}
vim.diagnostic.config({
  float = virtual_text_float_config,
  virtual_text = virtual_text_float_config,
  source = true,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '󰌵',
    },
  },
})

vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next({ wrap = false })
end)
vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev({ wrap = false })
end)
vim.keymap.set('n', '<leader>dd', function()
  if not vim.diagnostic.is_enabled() then
    vim.diagnostic.enable()
    print('Enabled diagnostics')
  else
    vim.diagnostic.enable(false)
    print('Disabled diagnostics')
  end
end)
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN }, wrap = false })
end)
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN }, wrap = false })
end)
