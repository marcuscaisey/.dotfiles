vim.keymap.set('i', 'jj', '<esc>')

vim.keymap.set('n', '<c-w><', '<c-w>5<')
vim.keymap.set('n', '<c-w>>', '<c-w>5>')
vim.keymap.set('n', '<c-w>-', '<c-w>5-')
vim.keymap.set('n', '<c-w>+', '<c-w>5+')

-- stylua: ignore start
vim.keymap.set('n', 'n', 'nzz', { desc = 'Repeat the latest "/" or "?", then redraw the current line at center of the window' })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Repeat the latest "/" or "?" in opposite direction, then redraw the current line at center of the window' })

vim.keymap.set({ 'o', 'v' }, 'ae', ':<c-u>execute "normal! gg" | keepjumps normal! VG<cr>', { desc = '"around everything" text object, selects everything in the buffer', silent = true })
-- stylua: ignore end

vim.keymap.set('n', '<leader>m', '<cmd>messages<cr>')

vim.keymap.set('n', 'J', 'm`J``', { desc = 'Join lines, keeping the cursor in its current position' })

vim.keymap.set('t', '<esc>', '<c-\\><c-n>', { desc = 'Go back to Normal mode' })

vim.keymap.set('n', '<leader>tw', function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt_local.wrap:get() then
    vim.opt_local.wrap = false
    print('Disabled line wrapping')
  else
    vim.opt_local.wrap = true
    print('Enabled line wrapping')
  end
end, { desc = 'Toggle line wrapping in the current window' })

vim.keymap.set('n', 'j', function()
  if vim.v.count > 0 then
    vim.cmd.normal({ string.format("m'%sj", vim.v.count), bang = true })
    return
  end
  vim.cmd.normal({ 'j', bang = true })
end, { desc = 'Move cursor down, setting the previous context mark if a count greater than 1 is provided' })
vim.keymap.set('n', 'k', function()
  if vim.v.count > 0 then
    vim.cmd.normal({ string.format("m'%sk", vim.v.count), bang = true })
    return
  end
  vim.cmd.normal({ 'k', bang = true })
end, { desc = 'Move cursor up, setting the previous context mark if a count greater than 1 is provided' })

vim.keymap.set('n', '<leader>yy', function()
  local git_root = vim.trim(vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait().stdout)
  local filepath = vim.api.nvim_buf_get_name(0)
  local relative_filepath = filepath:gsub('^' .. git_root .. '/', '')
  vim.fn.setreg('"', relative_filepath)
  vim.fn.setreg('*', relative_filepath)
  print(string.format('Yanked %s', relative_filepath))
end, { desc = 'Yank the path of the current buffer relative to the git root' })

vim.keymap.set('n', '<leader>YY', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  vim.fn.setreg('"', filepath)
  vim.fn.setreg('*', filepath)
  print(string.format('Yanked %s', filepath))
end, { desc = 'Yank the absolute path of the current buffer' })

vim.keymap.set('n', '<leader>ys', function()
  local git_root = vim.trim(vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait().stdout)
  local filepath = vim.api.nvim_buf_get_name(0)
  local relative_filepath = filepath:gsub('^' .. git_root .. '/', '')
  local line = unpack(vim.api.nvim_win_get_cursor(0))
  local base_url = vim.env.SOURCEGRAPH_BASE_URL
  if not base_url then
    vim.notify('Unable to yank sourcegraph URL: SOURCEGRAPH_BASE_URL env var not set', vim.log.levels.ERROR)
    return
  end
  local url = string.format('%s/-/blob/%s?L%d', base_url, relative_filepath, line)
  vim.fn.setreg('"', url)
  vim.fn.setreg('*', url)
  print(string.format('Yanked %s', url))
end, { desc = 'Yank the sourcegraph URL to the current position in the buffer' })

vim.keymap.set('n', '<leader>cb', function()
  -- filter buffers for changed property since bufmodified = 1 doesn't seem to filter out all unchanged buffers
  local changed_buffers = vim.tbl_filter(function(b)
    return b.changed == 1
  end, vim.fn.getbufinfo({ bufmodified = 1 }) or {})
  if #changed_buffers == 0 then
    print('No unsaved buffers')
    return
  end
  vim.fn.setqflist(changed_buffers)
  vim.cmd.copen()
  vim.cmd.cfirst()
end, { desc = 'Populate the quickfix list with any unsaved buffers' })
