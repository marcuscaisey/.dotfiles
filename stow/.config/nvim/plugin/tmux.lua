vim.api.nvim_create_autocmd('VimLeave', {
    group = vim.api.nvim_create_augroup('tmux.auto_window_renaming', { clear = true }),
    desc = 'Turn tmux automatic window renaming on',
    command = "if !empty($TMUX) | call system(['tmux', 'set-window-option', 'automatic-rename', 'on']) | endif",
})

vim.api.nvim_create_autocmd('DirChanged', {
    group = vim.api.nvim_create_augroup('tmux.rename_window', { clear = true }),
    desc = 'Rename the tmux window to $cwd:nvim',
    command = "if !empty($TMUX) | call system(['tmux', 'rename-window', fnamemodify(v:event.cwd, ':t') . ':nvim']) | endif",
})
