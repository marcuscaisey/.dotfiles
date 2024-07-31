vim.keymap.set('n', '<leader>q', function()
  local qf_window_id = vim.fn.getqflist({ winid = 0 }).winid
  local qf_open = qf_window_id > 0
  if qf_open then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end, { desc = 'Toggle quickfix window' })
vim.keymap.set('n', ']q', function()
  pcall(vim.cmd.cnext)
end, { desc = ':cnext' })
vim.keymap.set('n', '[q', function()
  pcall(vim.cmd.cprev)
end, { desc = ':cprev' })

vim.keymap.set('n', '<leader>l', function()
  local loc_window_id = vim.fn.getloclist(0, { winid = 0 }).winid
  local loc_open = loc_window_id > 0
  if loc_open then
    vim.cmd.lclose()
  else
    vim.cmd.lopen()
  end
end, { desc = 'Toggle location list window' })
vim.keymap.set('n', ']l', function()
  pcall(vim.cmd.lnext)
end, { desc = ':lnext' })
vim.keymap.set('n', '[l', function()
  pcall(vim.cmd.lprev)
end, { desc = ':lprev' })
