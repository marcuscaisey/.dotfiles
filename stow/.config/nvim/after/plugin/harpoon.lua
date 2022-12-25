local harpoon = require('harpoon')
local ui = require('harpoon.ui')
local mark = require('harpoon.mark')

harpoon.setup({
  menu = {
    width = 100,
  },
  global_settings = {
    mark_branch = true,
  },
})

vim.keymap.set('n', '<leader>ha', mark.add_file)
vim.keymap.set('n', '<leader>hh', ui.toggle_quick_menu)
for n = 1, 4 do
  vim.keymap.set('n', string.format('<leader>%d', n), function()
    ui.nav_file(n)
  end)
end
