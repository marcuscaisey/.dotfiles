local augroup = vim.api.nvim_create_augroup('tmux_window_renaming', { clear = true })

vim.api.nvim_create_autocmd({ 'VimLeave' }, {
  callback = function()
    if os.getenv('TMUX') then
      vim.system({ 'tmux', 'set-window-option', 'automatic-rename', 'on' })
    end
  end,
  group = augroup,
  desc = 'Turn tmux automatic window renaming on',
})

vim.api.nvim_create_autocmd({ 'DirChanged' }, {
  callback = function()
    if os.getenv('TMUX') then
      vim.system({ 'tmux', 'rename-window', vim.fs.basename(vim.v.event.cwd) .. ':nvim' })
    end
  end,
  group = augroup,
  desc = 'Rename the tmux window to $cwd:nvim',
})
