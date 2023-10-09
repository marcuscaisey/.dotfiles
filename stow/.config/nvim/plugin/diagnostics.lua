local virtual_text_float_config = {
  source = true,
  ---@param diagnostic Diagnostic
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
})

vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '󰌵', texthl = 'DiagnosticHint' })

vim.keymap.set('n', 'dK', vim.diagnostic.open_float)
vim.keymap.set('n', ']d', function()
  vim.diagnostic.goto_next({ wrap = false })
end)
vim.keymap.set('n', '[d', function()
  vim.diagnostic.goto_prev({ wrap = false })
end)
vim.keymap.set('n', '<leader>dd', function()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    print('Enabled diagnostics')
  else
    vim.diagnostic.disable()
    print('Disabled diagnostics')
  end
end)
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN }, wrap = false })
end)
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN }, wrap = false })
end)
