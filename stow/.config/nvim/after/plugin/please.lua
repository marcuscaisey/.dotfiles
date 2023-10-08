-- require all of these in a callback so that we can hot reload them
vim.keymap.set('n', '<leader>pj', function()
  require('please').jump_to_target()
end)
vim.keymap.set('n', '<leader>pb', function()
  require('please').build()
end)
vim.keymap.set('n', '<leader>pt', function()
  require('please').test()
end)
vim.keymap.set('n', '<leader>pct', function()
  require('please').test({ under_cursor = true })
end)
vim.keymap.set('n', '<leader>plt', function()
  require('please').test({ list = true })
end)
vim.keymap.set('n', '<leader>pft', function()
  require('please').test({ failed = true })
end)
vim.keymap.set('n', '<leader>pr', function()
  require('please').run()
end)
vim.keymap.set('n', '<leader>py', function()
  require('please').yank()
end)
vim.keymap.set('n', '<leader>pp', function()
  require('please.runners.popup').restore()
end)
vim.keymap.set('n', '<leader>pll', function()
  require('please.plugin').reload()
end)
vim.keymap.set('n', '<leader>pd', function()
  require('please').debug()
end)
vim.keymap.set('n', '<leader>pa', function()
  require('please').action_history()
end)
