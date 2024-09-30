local multicursor = require('multicursor-nvim')

multicursor.setup()

vim.keymap.set({ 'n', 'v' }, '<up>', function()
  multicursor.addCursor('k')
end, { desc = [[multicursor.addCursor('k')]] })
vim.keymap.set({ 'n', 'v' }, '<down>', function()
  multicursor.addCursor('j')
end, { desc = [[multicursor.addCursor('j')]] })

vim.keymap.set({ 'n', 'v' }, '<c-n>', function()
  multicursor.addCursor('*')
end, { desc = [[multicursor.addCursor('*')]] })

vim.keymap.set({ 'n', 'v' }, '<c-s>', function()
  multicursor.skipCursor('*')
end, { desc = [[multicursor.skipCursor('*')]] })

vim.keymap.set('n', '<esc>', function()
  if multicursor.hasCursors() then
    multicursor.clearCursors()
  end
end, { desc = 'multicursor.clearCursors()' })

vim.api.nvim_set_hl(0, 'MultiCursorCursor', { link = 'Cursor' })
vim.api.nvim_set_hl(0, 'MultiCursorVisual', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'MultiCursorSign', { link = 'SignColumn' })
vim.api.nvim_set_hl(0, 'MultiCursorDisabledCursor', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
vim.api.nvim_set_hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
