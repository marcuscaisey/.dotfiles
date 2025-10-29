local ok, please = pcall(require, 'please')
if not ok then
  return
end

vim.keymap.set('n', '<leader>pb', please.build)
vim.keymap.set('n', '<leader>pr', please.run)
vim.keymap.set('n', '<leader>pt', please.test)
vim.keymap.set('n', '<leader>pct', function()
  please.test({ under_cursor = true })
end)
vim.keymap.set('n', '<leader>pd', please.debug)
vim.keymap.set('n', '<leader>pcd', function()
  please.debug({ under_cursor = true })
end)
vim.keymap.set('n', '<leader>ph', please.history)
vim.keymap.set('n', '<leader>pch', please.clear_history)
vim.keymap.set('n', '<leader>pp', please.set_profile)
vim.keymap.set('n', '<leader>pm', please.maximise_popup)
vim.keymap.set('n', '<leader>pj', please.jump_to_target)
vim.keymap.set('n', '<leader>pl', please.look_up_target)
vim.keymap.set('n', '<leader>py', please.yank)
