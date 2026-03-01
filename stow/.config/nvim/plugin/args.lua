vim.keymap.set('n', '<Leader>aa', '<Cmd>$arge % | argdedupe | args<CR>')
vim.keymap.set('n', '<Leader>as', '<Cmd>args<CR>')
vim.keymap.set('n', '<Leader>ac', '<Cmd>argdelete * | args<CR>')
for i = 0, 9 do
  vim.keymap.set('n', string.format('<Leader>%d', i), string.format('<Cmd>argument %d | args<CR>', i))
end
