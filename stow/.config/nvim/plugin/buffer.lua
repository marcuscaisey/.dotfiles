local augroup = vim.api.nvim_create_augroup('buffer', { clear = true })

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = augroup,
  desc = 'Jump to last file position',
  callback = function(args)
    local pos = vim.api.nvim_buf_get_mark(args.buf, '"')
    if pos[1] >= 1 and pos[1] <= vim.fn.line('$') and not vim.tbl_contains({ 'gitcommit', 'gitrebase' }, vim.o.filetype) then
      vim.api.nvim_win_set_cursor(0, pos)
    end
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup,
  desc = 'Trim trailing whitespace',
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd('silent! undojoin')
    vim.cmd('silent keepjumps keeppatterns %s/\\s\\+$//e')
    vim.fn.winrestview(view)
  end,
})
