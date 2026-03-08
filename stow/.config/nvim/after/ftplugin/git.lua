vim.keymap.set('n', '<Leader>yy', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  local hash = filepath:match('.+/%.git//(.+)')
  vim.fn.setreg('"', hash)
  vim.fn.setreg('*', hash)
  print(string.format('Yanked %s', hash))
end, { desc = 'Yank the hash of the commit patch', buffer = true })

local clients = vim.lsp.get_clients({ bufnr = 0 })
for _, client in ipairs(clients) do
  vim.lsp.buf_detach_client(0, client.id)
end
