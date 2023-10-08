local ok, harpoon = pcall(require, 'harpoon')
if not ok then
  return
end
local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

harpoon.setup({
  menu = {
    width = 100,
  },
  global_settings = {
    mark_branch = true,
  },
})

vim.keymap.set('n', '<leader>ha', mark.add_file, { desc = 'Mark file to be revisited later on with Harpoon' })
vim.keymap.set('n', '<leader>hh', ui.toggle_quick_menu, { desc = 'View all Harpoon marks' })
for i = 1, 4 do
  vim.keymap.set('n', string.format('<leader>%d', i), function()
    ui.nav_file(i)
  end, { desc = string.format('Navigate to Harpoon mark %d', i) })
end
