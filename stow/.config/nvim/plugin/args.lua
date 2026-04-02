vim.keymap.set('n', '<Leader>aa', '<Cmd>$argedit % | argdedupe | args<CR>', { desc = 'Add file to argument list' })
vim.keymap.set('n', '<Leader>al', '<Cmd>args<CR>', { desc = 'List argument list' })
vim.keymap.set('n', '<Leader>ac', '<Cmd>argdelete * | args<CR>', { desc = 'Clear argument list' })
for i = 0, 9 do
    -- stylua: ignore start
    vim.keymap.set('n', string.format('<Leader>%d', i), string.format('<Cmd>argument %d | args<CR>', i), { desc = string.format('Jump to file %d in argument list', i) })
    -- stylua: ignore end
end
