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

vim.keymap.set({ 'n', 'v' }, '<Up>', function()
  multicursor.addCursor('k')
end, { desc = [[multicursor.addCursor('k')]] })
vim.keymap.set({ 'n', 'v' }, '<Down>', function()
  multicursor.addCursor('j')
end, { desc = [[multicursor.addCursor('j')]] })

vim.keymap.set({ 'n', 'v' }, '<C-N>', function()
  multicursor.addCursor('*')
end, { desc = [[multicursor.addCursor('*')]] })

vim.keymap.set({ 'n', 'v' }, '<C-S>', function()
  multicursor.skipCursor('*')
end, { desc = [[multicursor.skipCursor('*')]] })

vim.keymap.set('n', '<Esc>', function()
  if multicursor.hasCursors() then
    multicursor.clearCursors()
  end
end, { desc = 'multicursor.clearCursors()' })
