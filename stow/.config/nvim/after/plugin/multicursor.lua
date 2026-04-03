local ok, multicursor = pcall(require, 'multicursor-nvim')
if not ok then
    return
end

multicursor.setup()

vim.keymap.set({ 'n', 'v' }, '<Up>', '<Cmd>lua require("multicursor-nvim").lineAddCursor(-1)<CR>', { desc = 'Add cursor to line below' })
vim.keymap.set({ 'n', 'v' }, '<Down>', '<Cmd>lua require("multicursor-nvim").lineAddCursor(1)<CR>', { desc = 'Add cursor to line above' })
vim.keymap.set({ 'n', 'v' }, '<C-N>', '<Cmd>lua require("multicursor-nvim").matchAddCursor(1)<CR>', { desc = 'Add cursor to next matching word' })
vim.keymap.set({ 'n', 'v' }, '<C-S>', '<Cmd>lua require("multicursor-nvim").matchSkipCursor(1)<CR>', { desc = 'Move cursor to next matching word' })
vim.keymap.set('n', '<Esc>', '<Cmd>lua require("multicursor-nvim").clearCursors()<CR>', { desc = 'Clear cursors' })
