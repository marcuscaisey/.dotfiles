local ok, treesitter_textobjects = pcall(require, 'nvim-treesitter-textobjects')
if not ok then
  return
end
local move = require('nvim-treesitter-textobjects.move')
local select = require('nvim-treesitter-textobjects.select')

treesitter_textobjects.setup({
  select = {
    lookahead = true,
    selection_modes = {
      ['@function.outer'] = 'V',
      ['@function.inner'] = 'V',
    },
  },
})

vim.keymap.set({ 'x', 'o' }, 'af', function()
  select.select_textobject('@function.outer', 'textobjects')
end, { desc = [[nvim-treesitter-textobjects.select.select_textobject('@function.outer', 'textobjects')]] })
vim.keymap.set({ 'x', 'o' }, 'if', function()
  select.select_textobject('@function.inner', 'textobjects')
end, { desc = [[nvim-treesitter-textobjects.select.select_textobject('@function.inner', 'textobjects')]] })
vim.keymap.set({ 'x', 'o' }, 'ia', function()
  select.select_textobject('@parameter.inner', 'textobjects')
end, { desc = [[nvim-treesitter-textobjects.select.select_textobject('@parameter.inner', 'textobjects')]] })
vim.keymap.set({ 'x', 'o' }, 'aa', function()
  select.select_textobject('@parameter.outer', 'textobjects')
end, { desc = [[nvim-treesitter-textobjects.select.select_textobject('@parameter.outer', 'textobjects')]] })
vim.keymap.set({ 'x', 'o' }, 'ic', function()
  select.select_textobject('@call.inner', 'textobjects')
end, { desc = [[nvim-treesitter-textobjects.select.select_textobject('@call.inner', 'textobjects')]] })
vim.keymap.set({ 'x', 'o' }, 'ac', function()
  select.select_textobject('@call.outer', 'textobjects')
end, { desc = [[nvim-treesitter-textobjects.select.select_textobject('@call.outer', 'textobjects')]] })
vim.keymap.set({ 'x', 'o' }, 'iv', function()
  select.select_textobject('@assignment.inner', 'textobjects')
end, { desc = [[nvim-treesitter-textobjects.select.select_textobject('@assignment.inner', 'textobjects')]] })
vim.keymap.set({ 'x', 'o' }, 'av', function()
  select.select_textobject('@assignment.outer', 'textobjects')
end, { desc = [[nvim-treesitter-textobjects.select.select_textobject('@assignment.outer', 'textobjects')]] })
vim.keymap.set({ 'x', 'o' }, 'ib', function()
  select.select_textobject('@block.inner', 'textobjects')
end, { desc = [[nvim-treesitter-textobjects.select.select_textobject('@block.inner', 'textobjects')]] })
vim.keymap.set({ 'x', 'o' }, 'ab', function()
  select.select_textobject('@block.outer', 'textobjects')
end, { desc = [[nvim-treesitter-textobjects.select.select_textobject('@block.outer', 'textobjects')]] })

vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
  move.goto_next_start('@function.outer', 'textobjects')
end, { desc = [[nvim-treesitter-textobjects.move.goto_next_start('@function.outer', 'textobjects')]] })
vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
  move.goto_previous_start('@function.outer', 'textobjects')
end, { desc = [[nvim-treesitter-textobjects.move.goto_previous_start('@function.outer', 'textobjects')]] })
vim.keymap.set({ 'n', 'x', 'o' }, ']a', function()
  move.goto_next_start('@parameter.inner', 'textobjects')
end, { desc = [[nvim-treesitter-textobjects.move.goto_next_start('@parameter.inner', 'textobjects')]] })
vim.keymap.set({ 'n', 'x', 'o' }, '[a', function()
  move.goto_previous_start('@parameter.inner', 'textobjects')
end, { desc = [[nvim-treesitter-textobjects.move.goto_previous_start('@parameter.inner', 'textobjects')]] })
