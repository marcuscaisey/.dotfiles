local augroup = vim.api.nvim_create_augroup('buffer', { clear = true })

vim.api.nvim_create_autocmd('BufWinEnter', {
  callback = function()
    local last_line = vim.fn.line([['"]])
    local lines = vim.fn.line('$')
    if last_line ~= 0 and last_line <= lines then
      local last_col = vim.fn.col([['"]])
      vim.api.nvim_win_set_cursor(0, { last_line, last_col })
    end
  end,
  group = augroup,
  desc = 'Jump to last file position',
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
