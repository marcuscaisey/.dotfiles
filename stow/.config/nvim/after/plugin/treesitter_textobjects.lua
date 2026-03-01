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

local select_keymaps = {
  af = '@function.outer',
  ['if'] = '@function.inner',
  ia = '@parameter.inner',
  aa = '@parameter.outer',
  ic = '@call.inner',
  ac = '@call.outer',
  iv = '@assignment.inner',
  av = '@assignment.outer',
  ib = '@block.inner',
  ab = '@block.outer',
}
local goto_next_start_keymaps = {
  [']f'] = '@function.outer',
  [']a'] = '@parameter.inner',
  [']m'] = '@method.outer',
}
local goto_next_end_keymaps = {
  [']F'] = '@function.outer',
}
local goto_previous_start_keymaps = {
  ['[f'] = '@function.outer',
  ['[a'] = '@parameter.inner',
}
local goto_previous_end_keymaps = {
  ['[F'] = '@function.outer',
}

for lhs, query_group in pairs(select_keymaps) do
  vim.keymap.set({ 'x', 'o' }, lhs, function()
    select.select_textobject(query_group, 'textobjects')
  end, { desc = string.format([[nvim-treesitter-textobjects.select.select_textobject('%s', 'textobjects')]], query_group) })
end
for lhs, query_group in pairs(goto_next_start_keymaps) do
  vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
    move.goto_next_start(query_group, 'textobjects')
  end, { desc = string.format([[nvim-treesitter-textobjects.move.goto_next_start('%s', 'textobjects')]], query_group) })
end
for lhs, query_group in pairs(goto_next_end_keymaps) do
  vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
    move.goto_next_end(query_group, 'textobjects')
  end, { desc = string.format([[nvim-treesitter-textobjects.move.goto_next_end('%s', 'textobjects')]], query_group) })
end
for lhs, query_group in pairs(goto_previous_start_keymaps) do
  vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
    move.goto_previous_start(query_group, 'textobjects')
  end, { desc = string.format([[nvim-treesitter-textobjects.move.goto_previous_start('%s', 'textobjects')]], query_group) })
end
for lhs, query_group in pairs(goto_previous_end_keymaps) do
  vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
    move.goto_previous_end(query_group, 'textobjects')
  end, { desc = string.format([[nvim-treesitter-textobjects.move.goto_previous_end('%s', 'textobjects')]], query_group) })
end
