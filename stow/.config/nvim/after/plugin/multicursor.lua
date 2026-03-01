local ok, multicursor = pcall(require, 'multicursor-nvim')
if not ok then
  return
end

multicursor.setup()

vim.api.nvim_set_hl(0, 'MultiCursorCursor', { link = 'Cursor' })
vim.api.nvim_set_hl(0, 'MultiCursorVisual', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'MultiCursorSign', { link = 'SignColumn' })
vim.api.nvim_set_hl(0, 'MultiCursorDisabledCursor', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })

vim.keymap.set({ 'n', 'v' }, '<Up>', '<Cmd>lua require("multicursor-nvim").addCursor("k")<CR>')
vim.keymap.set({ 'n', 'v' }, '<Down>', '<Cmd>lua require("multicursor-nvim").addCursor("j")<CR>')
vim.keymap.set({ 'n', 'v' }, '<C-N>', '<Cmd>lua require("multicursor-nvim").addCursor("*")<CR>')
vim.keymap.set({ 'n', 'v' }, '<C-S>', '<Cmd>lua require("multicursor-nvim").skipCursor("*")<CR>')
vim.keymap.set('n', '<Esc>', '<Cmd>lua require("multicursor-nvim").clearCursors()<CR>')
