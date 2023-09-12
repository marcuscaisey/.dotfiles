vim.g.mapleader = ' '

vim.keymap.set('i', 'jj', '<esc>', { desc = 'End Insert or Replace mode, go back to Normal mode' })

vim.keymap.set({ 'n', 'v' }, 'gh', '^', { desc = 'Jump to the first non-blank character of the line' })
vim.keymap.set({ 'n', 'v' }, 'gj', 'G', { desc = 'Jump to the last line' })
vim.keymap.set({ 'n', 'v' }, 'gk', 'gg', { desc = 'Jump to the first line' })
vim.keymap.set({ 'n', 'v' }, 'gl', 'g_', { desc = 'Jump to the last non-blank character of the line' })

vim.keymap.set('n', '<c-w><', '<c-w>5<', { desc = 'Decrease current window width by 5' })
vim.keymap.set('n', '<c-w>>', '<c-w>5>', { desc = 'Increase current window width by 5' })
vim.keymap.set('n', '<c-w>-', '<c-w>5-', { desc = 'Decrease current window height by 5' })
vim.keymap.set('n', '<c-w>+', '<c-w>5+', { desc = 'Increase current window height by 5' })

-- stylua: ignore start
vim.keymap.set('n', 'n', 'nzz',
  { desc = 'Repeat the latest "/" or "?", then redraw the current line at center of the window' })
vim.keymap.set('n', 'N', 'Nzz',
  { desc = 'Repeat the latest "/" or "?" in opposite direction, then redraw the current line at center of the window' })
-- stylua: ignore end

vim.keymap.set({ 'o', 'v' }, 'ae', ':<c-u>execute "normal! gg" | keepjumps normal! VG<cr>',
  { desc = '"around everything" text object, selects everything in the buffer', silent = true })

vim.keymap.set('n', '<leader>m', '<cmd>messages<cr>', { desc = 'Show all messages' })

vim.keymap.set('n', 'J', 'm`J``', { desc = 'Join lines, keeping the cursor in its current position' })

vim.keymap.set('t', '<esc>', '<c-\\><c-n>', { desc = 'Go back to Normal mode' })

vim.keymap.set('v', 'p', 'P', { desc = 'Replace the selected text without changing the unnamed register' })

vim.keymap.set('n', '<leader>so', function()
  local file = vim.api.nvim_buf_get_name(0)
  print('Sourced ' .. file)
  vim.cmd.source(file)
end, { desc = 'Source the current file' })

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

vim.keymap.set('n', ']g', function()
  vim.fn.search([[GIVEN\|WHEN\|THEN]], 'W')
end, { desc = 'Jump to next GIVEN / WHEN / THEN' })
vim.keymap.set('n', '[g', function()
  vim.fn.search([[GIVEN\|WHEN\|THEN]], 'bW')
end, { desc = 'Jump to previous GIVEN / WHEN / THEN' })

vim.keymap.set('n', '<leader>y', function()
  local git_root = vim.trim(vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait().stdout)
  local filepath = vim.api.nvim_buf_get_name(0)
  local relative_filepath = filepath:gsub('^' .. git_root .. '/', '')
  vim.fn.setreg('"', relative_filepath)
  vim.fn.setreg('*', relative_filepath)
  print(string.format('Yanked %s', relative_filepath))
end, { desc = 'Yank the path of the current buffer relative to the git root' })

vim.keymap.set('n', '<leader>sy', function()
  local git_root = vim.trim(vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait().stdout)
  local filepath = vim.api.nvim_buf_get_name(0)
  local relative_filepath = filepath:gsub('^' .. git_root .. '/', '')
  local line = unpack(vim.api.nvim_win_get_cursor(0))
  local relative_filepath_with_line = string.format('%s?L%d', relative_filepath, line)
  vim.fn.setreg('"', relative_filepath_with_line)
  vim.fn.setreg('*', relative_filepath_with_line)
  print(string.format('Yanked %s', relative_filepath_with_line))
end, { desc = 'Yank the path of the current buffer relative to the git root in sourcegraph search format' })

vim.keymap.set('n', '<leader>cb', function()
  -- filter buffers for changed property since bufmodified = 1 doesn't seem to filter out all unchanged buffers
  local changed_buffers = vim.tbl_filter(
    function(b)
      return b.changed == 1
    end,
    vim.fn.getbufinfo({
      bufmodified = 1,
    })
  )
  if #changed_buffers == 0 then
    print('No unsaved buffers')
    return
  end
  vim.fn.setqflist(changed_buffers)
  vim.cmd.copen()
  vim.cmd.cfirst()
end, { desc = 'Populate the quickfix list with any unsaved buffers' })

vim.keymap.set('n', '<leader>gf', function()
  local git_root = vim.trim(vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait().stdout)
  local files = vim.split(
    vim
      .system({
        'git',
        '-C',
        git_root,
        'ls-files',
        '--modified',
        '--others',
        '--exclude-standard',
        '--full-name',
        '--deduplicate',
      })
      :wait().stdout,
    '\n',
    { trimempty = true }
  )

  if #files == 0 then
    print('No Git changes')
    return
  end

  local qflist = {}
  for _, file in ipairs(files) do
    table.insert(qflist, {
      filename = git_root .. '/' .. file,
      lnum = 1,
      col = 1,
    })
  end
  vim.fn.setqflist(qflist)
  vim.cmd.copen()
  vim.cmd.cfirst()
end, { desc = 'Populate the quickfix list with all modified or untracked git files' })
