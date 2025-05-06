local augroup = vim.api.nvim_create_augroup('quickfix', { clear = true })

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  group = augroup,
  pattern = '*',
  desc = 'Sort quickfix list items',
  callback = function()
    local qflist = vim.fn.getqflist()
    table.sort(qflist, function(a, b)
      local a_name = vim.api.nvim_buf_get_name(a.bufnr)
      local b_name = vim.api.nvim_buf_get_name(b.bufnr)
      if a_name ~= b_name then
        return a_name < b_name
      end
      if a.lnum ~= b.lnum then
        return a.lnum < b.lnum
      end
      return a.col < b.col
    end)
    vim.fn.setqflist(qflist, 'r')
  end,
})

vim.keymap.set('n', '<Leader>q', function()
  local qf_window_id = vim.fn.getqflist({ winid = 0 }).winid
  local qf_open = qf_window_id > 0
  if qf_open then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end, { desc = 'Toggle quickfix window' })

vim.keymap.set('n', '<Leader>l', function()
  local loc_window_id = vim.fn.getloclist(0, { winid = 0 }).winid
  local loc_open = loc_window_id > 0
  if loc_open then
    vim.cmd.lclose()
  else
    vim.cmd.lopen()
  end
end, { desc = 'Toggle location list window' })
