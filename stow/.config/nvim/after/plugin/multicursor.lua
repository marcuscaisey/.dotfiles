local ok, multicursor = pcall(require, 'multicursor-nvim')
if not ok then
  return
end

multicursor.setup()

vim.keymap.set({ 'n', 'v' }, '<Up>', '<Cmd>lua require("multicursor-nvim").addCursor("k")<CR>')
vim.keymap.set({ 'n', 'v' }, '<Down>', '<Cmd>lua require("multicursor-nvim").addCursor("j")<CR>')
vim.keymap.set({ 'n', 'v' }, '<C-N>', '<Cmd>lua require("multicursor-nvim").addCursor("*")<CR>')
vim.keymap.set({ 'n', 'v' }, '<C-S>', '<Cmd>lua require("multicursor-nvim").skipCursor("*")<CR>')
vim.keymap.set('n', '<Esc>', '<Cmd>lua require("multicursor-nvim").clearCursors()<CR>')
