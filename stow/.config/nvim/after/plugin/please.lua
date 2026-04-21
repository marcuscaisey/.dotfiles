local ok, please = pcall(require, 'please')
if not ok then
    return
end

please.setup({
    puku_command = { 'puku' },
})

vim.keymap.set('n', '<leader>pb', '<Cmd>Please build<CR>', { desc = 'Build please target' })
vim.keymap.set('n', '<leader>pr', '<Cmd>Please run<CR>', { desc = 'Run please target' })
vim.keymap.set('n', '<leader>pt', '<Cmd>Please test<CR>', { desc = 'Test please target' })
vim.keymap.set('n', '<leader>pct', '<Cmd>Please test under_cursor<CR>', { desc = 'Test please target (test under cursor)' })
vim.keymap.set('n', '<leader>pd', '<Cmd>Please debug<CR>', { desc = 'Debug please target' })
vim.keymap.set('n', '<leader>pcd', '<Cmd>Please debug under_cursor<CR>', { desc = 'Debug please target (test under cursor)' })
vim.keymap.set('n', '<leader>ph', '<Cmd>Please history<CR>', { desc = 'List please command history' })
vim.keymap.set('n', '<leader>pch', '<Cmd>Please clear_history<CR>', { desc = 'Clear please command history' })
vim.keymap.set('n', '<leader>pp', '<Cmd>Please set_profile<CR>', { desc = 'Set please profile' })
vim.keymap.set('n', '<leader>pm', '<Cmd>Please maximise_popup<CR>', { desc = 'Maximise please popup' })
vim.keymap.set('n', '<leader>pj', '<Cmd>Please jump_to_target<CR>', { desc = 'Jump to please target' })
vim.keymap.set('n', '<leader>pl', '<Cmd>Please look_up_target<CR>', { desc = 'Look up please target' })
vim.keymap.set('n', '<leader>py', '<Cmd>Please yank<CR>', { desc = 'Yank please target' })
