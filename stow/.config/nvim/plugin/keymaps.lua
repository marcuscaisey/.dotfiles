vim.keymap.set('i', 'jj', '<Esc>')

vim.keymap.set('n', '<C-W><', '<C-W>5<')
vim.keymap.set('n', '<C-W>>', '<C-W>5>')
vim.keymap.set('n', '<C-W>-', '<C-W>5-')
vim.keymap.set('n', '<C-W>+', '<C-W>5+')

vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

vim.keymap.set({ 'o', 'v' }, 'ae', ':<C-U>execute "normal! gg" | keepjumps normal! VG<CR>', {
  desc = '"around everything" text object, selects everything in the buffer',
  silent = true,
})

vim.keymap.set('n', '<C-]>', '<Cmd>silent! normal! <C-]><CR>')

vim.keymap.set('n', '<Leader>m', '<Cmd>messages<CR>')

vim.keymap.set('n', 'J', 'm`J``', { desc = 'Join lines, keeping the cursor in its current position' })

vim.keymap.set('t', '<Esc>', '<C-\\><C-N>', { desc = 'Go back to Normal mode' })

vim.keymap.set('i', '<CR>', 'pumvisible() ? "<C-E><CR>" : "<CR>"', { expr = true })
vim.keymap.set('i', '<Tab>', 'pumvisible() ? "<C-E><Tab>" : "<Tab>"', { expr = true })

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

vim.keymap.set('n', '<Leader>yy', function()
  local git_root = vim.trim(vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait().stdout)
  local filepath = vim.api.nvim_buf_get_name(0)
  local relative_filepath = filepath:gsub('^' .. git_root .. '/', '')
  vim.fn.setreg('"', relative_filepath)
  vim.fn.setreg('*', relative_filepath)
  print(string.format('Yanked %s', relative_filepath))
end, { desc = 'Yank the path of the current buffer relative to the git root' })

vim.keymap.set('n', '<Leader>YY', function()
  local filepath = vim.api.nvim_buf_get_name(0)
  vim.fn.setreg('"', filepath)
  vim.fn.setreg('*', filepath)
  print(string.format('Yanked %s', filepath))
end, { desc = 'Yank the absolute path of the current buffer' })

vim.keymap.set('n', '<Leader>ys', function()
  local base_url = vim.env.SOURCEGRAPH_BASE_URL
  if not base_url then
    vim.notify('Unable to yank sourcegraph URL: SOURCEGRAPH_BASE_URL env var not set', vim.log.levels.ERROR)
    return
  end

  local git_root = vim.trim(vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait().stdout)
  local filepath = vim.api.nvim_buf_get_name(0)
  local relative_filepath = filepath:gsub('^' .. vim.pesc(git_root) .. '/', '')

  local git_ref
  local upstream_branch = vim.trim(vim.system({ 'git', 'rev-parse', '--abbrev-ref', '@{upstream}' }):wait().stdout)
  if upstream_branch ~= '' then
    local remote_branch = upstream_branch:match('^origin/(.+)')
    if remote_branch then
      git_ref = remote_branch
    end
  else
    local tag = vim.trim(vim.system({ 'git', 'tag', '--points-at', 'HEAD' }):wait().stdout)
    if tag then
      git_ref = tag
    end
  end

  local git_ref_segment = git_ref and '@' .. git_ref or ''
  local line = unpack(vim.api.nvim_win_get_cursor(0))
  local url = string.format('%s%s/-/blob/%s?L%d', base_url, git_ref_segment, relative_filepath, line)

  vim.fn.setreg('"', url)
  vim.fn.setreg('*', url)
  print(string.format('Yanked %s', url))
end, { desc = 'Yank the sourcegraph URL to the current position in the buffer' })
