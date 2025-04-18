vim.keymap.set('i', 'jj', '<Esc>')

vim.keymap.set('n', '<C-W><', '<C-W>5<')
vim.keymap.set('n', '<C-W>>', '<C-W>5>')
vim.keymap.set('n', '<C-W>-', '<C-W>5-')
vim.keymap.set('n', '<C-W>+', '<C-W>5+')

vim.keymap.set('n', '<C-]>', '<Cmd>silent! normal! <C-]><CR>')

vim.keymap.set('n', '<Leader>m', '<Cmd>messages<CR>')

vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { desc = 'Go back to Normal mode' })

vim.keymap.set('n', '<Leader>f', function()
  if vim.bo.formatexpr == '' and vim.bo.formatprg == '' then
    print('Skipping formatting because neither formatprg or formatexpr are set')
    return '<Ignore>'
  end
  return table.concat({
    'ma', -- Set mark 'a' at cursor position
    'H', -- Move to top of window
    'mb', -- Set mark 'b' at top of window
    'gg', -- Move to first line
    'gqG', -- Format to last line
    '`b', -- Move to top of window mark 'b'
    'zt', -- Redraw line at top of window
    '`a', -- Move to cursor position mark 'a'
  })
end, { desc = 'Format the entire buffer', expr = true, silent = true })

vim.keymap.set('n', '<Leader>tw', function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt_local.wrap:get() then
    vim.opt_local.wrap = false
    print('Disabled line wrapping')
  else
    vim.opt_local.wrap = true
    print('Enabled line wrapping')
  end
end, { desc = 'Toggle line wrapping in the current window' })
