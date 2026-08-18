local ok, please = pcall(require, 'please')
if not ok then
    return
end

please.setup({
    formatting = { puku_command = { 'puku' } },
})

vim.keymap.set('n', '<leader>pb', '<Cmd>Please build<CR>')
vim.keymap.set('n', '<leader>pr', '<Cmd>Please run<CR>')
vim.keymap.set('n', '<leader>pt', '<Cmd>Please test<CR>')
vim.keymap.set('n', '<leader>pT', '<Cmd>Please test under_cursor<CR>')
vim.keymap.set('n', '<leader>pc', '<Cmd>Please cover quickfix<CR>')
vim.keymap.set('n', '<leader>pC', '<Cmd>Please cover quickfix under_cursor<CR>')
vim.keymap.set('n', '<leader>pv', '<Cmd>Please toggle_coverage_highlighting<CR>')
vim.keymap.set('n', '<leader>pd', '<Cmd>Please debug<CR>')
vim.keymap.set('n', '<leader>pD', '<Cmd>Please debug under_cursor<CR>')
vim.keymap.set('n', '<leader>ph', '<Cmd>Please history<CR>')
vim.keymap.set('n', '<leader>pH', '<Cmd>Please clear_history<CR>')
vim.keymap.set('n', '<leader>pp', '<Cmd>Please set_profile<CR>')
vim.keymap.set('n', '<leader>pm', '<Cmd>Please maximise_popup<CR>')
vim.keymap.set('n', '<leader>pj', '<Cmd>Please jump_to_target<CR>')
vim.keymap.set('n', '<leader>pl', '<Cmd>Please look_up_target<CR>')
vim.keymap.set('n', '<leader>py', '<Cmd>Please yank<CR>')
