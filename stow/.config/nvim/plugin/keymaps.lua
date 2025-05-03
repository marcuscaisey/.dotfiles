vim.keymap.set('i', 'jj', '<Esc>')

vim.keymap.set('n', '<C-W><', '<C-W>5<')
vim.keymap.set('n', '<C-W>>', '<C-W>5>')
vim.keymap.set('n', '<C-W>-', '<C-W>5-')
vim.keymap.set('n', '<C-W>+', '<C-W>5+')

vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { desc = 'Go back to Normal mode' })

vim.keymap.set('n', '<Leader>f', function()
  if vim.bo.formatexpr == '' and vim.bo.formatprg == '' then
    print('Skipping formatting because neither formatprg or formatexpr are set')
    return
  end
  local view = vim.fn.winsaveview()
  vim.cmd('silent keepjumps normal! gggqG')
  local errmsg
  if vim.v.shell_error > 0 then
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    errmsg = table.concat(lines, '\n')
    vim.cmd('silent undo')
  end
  vim.fn.winrestview(view)
  if errmsg then
    vim.notify(errmsg, vim.log.levels.ERROR)
  end
end, { desc = 'Format the entire buffer', silent = true })

vim.keymap.set('n', '<Leader>tw', function()
  vim.wo.wrap = not vim.wo.wrap
  if vim.wo.wrap then
    print('Enabled line wrapping')
  else
    print('Disabled line wrapping')
  end
end, { desc = 'Toggle line wrapping in the current window' })
