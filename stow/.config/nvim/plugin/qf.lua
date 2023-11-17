vim.api.nvim_create_autocmd('WinClosed', {
  callback = function(args)
    local closed_winid = tonumber(args.match)
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
      if winid ~= closed_winid then
        local bufnr = vim.api.nvim_win_get_buf(winid)
        if vim.bo[bufnr].filetype ~= 'qf' then
          return
        end
      end
    end
    vim.cmd.quitall()
  end,
  group = vim.api.nvim_create_augroup('qf', { clear = true }),
  desc = 'Quit if last open window is the quickfix',
})

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
end, { desc = 'Jump to the next item in the quickfix list' })
vim.keymap.set('n', '[q', function()
  pcall(vim.cmd.cprev)
end, { desc = 'Jump to the previous item in the quickfix list' })

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
end, { desc = 'Jump to the next item in the location list' })
vim.keymap.set('n', '[l', function()
  pcall(vim.cmd.lprev)
end, { desc = 'Jump to the previous item in the location list' })
