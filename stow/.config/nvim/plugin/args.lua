vim.keymap.set('n', '<Leader>aa', '<Cmd>argadd | argdedupe<CR>')
vim.keymap.set('n', '<Leader>ac', '<Cmd>argdelete *<CR>')
for i = 0, 9 do
  vim.keymap.set('n', string.format('<Leader>%d', i), string.format('<Cmd>argument %d<CR>', i))
end
