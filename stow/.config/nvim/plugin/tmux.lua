vim.api.nvim_create_autocmd('VimLeave', {
    desc = 'Turn tmux automatic window renaming on',
    group = vim.api.nvim_create_augroup('tmux.auto_window_renaming', { clear = true }),
    command = "if !empty($TMUX) | call system(['tmux', 'set-window-option', 'automatic-rename', 'on']) | endif",
})

vim.api.nvim_create_autocmd('DirChanged', {
    desc = 'Rename the tmux window to $cwd:nvim',
    group = vim.api.nvim_create_augroup('tmux.rename_window', { clear = true }),
    command = "if !empty($TMUX) | call system(['tmux', 'rename-window', fnamemodify(v:event.cwd, ':t') . ':nvim']) | endif",
})
