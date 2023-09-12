local group = vim.api.nvim_create_augroup('misc', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local last_line = vim.fn.line([['"]])
    local lines = vim.fn.line('$')
    if last_line ~= 0 and last_line <= lines then
      local last_col = vim.fn.col([['"]])
      vim.api.nvim_win_set_cursor(0, { last_line, last_col })
    end
  end,
  group = group,
  desc = 'Jump to last file position',
})

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    local file_extension = vim.fn.expand('%:e')
    if file_extension ~= 'diff' then
      vim.cmd('%s/\\s\\+$//e')
    end
  end,
  group = group,
  desc = 'Trim trailing whitespace',
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 1000 })
  end,
  group = group,
  desc = 'Highlight yanked text',
})

vim.api.nvim_create_autocmd({ 'VimLeave' }, {
  callback = function()
    if os.getenv('TMUX') then
      vim.system({ 'tmux', 'set-window-option', 'automatic-rename', 'on' })
    end
  end,
  group = group,
  desc = 'Turn tmux automatic window renaming on',
})

vim.api.nvim_create_autocmd({ 'DirChanged' }, {
  callback = function()
    if os.getenv('TMUX') then
      vim.system({ 'tmux', 'rename-window', vim.fs.basename(vim.v.event.cwd) .. ':nvim' })
    end
  end,
  group = group,
  desc = 'Rename the tmux window to $cwd:nvim',
})
