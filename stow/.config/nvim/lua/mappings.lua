vim.g.mapleader = ' '
vim.g.camelcasemotion_key = '<leader>'

vim.keymap.set('i', 'jj', '<esc>')

vim.keymap.set({ 'n', 'v' }, 'gk', 'gg')
vim.keymap.set({ 'n', 'v' }, 'gj', 'G')
vim.keymap.set({ 'n', 'v' }, 'gh', '^')
vim.keymap.set('n', 'gl', '$')
vim.keymap.set('v', 'gl', 'g_')

vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-w>j', '<c-w>J')
vim.keymap.set('n', '<c-w>k', '<c-w>K')
vim.keymap.set('n', '<c-w>l', '<c-w>L')
vim.keymap.set('n', '<c-w>h', '<c-w>H')
vim.keymap.set('n', '<c-w><', '<c-w>5<')
vim.keymap.set('n', '<c-w>>', '<c-w>5>')
vim.keymap.set('n', '<c-w>-', '<c-w>5-')
vim.keymap.set('n', '<c-w>=', '<c-w>5+')
vim.keymap.set('n', '<c-w>e', '<c-w>=')

vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '<c-d>', '<c-d>zz')
vim.keymap.set('n', '<c-u>', '<c-u>zz')

vim.keymap.set('i', 'II', '<esc>I')
vim.keymap.set('i', 'AA', '<esc>A')

vim.keymap.set('t', '<esc>', '<c-\\><c-n>')

-- When i use vim.keymap.set to create this, nothing appears in the command line when i trigger the mapping until i press another
-- key. Not sure why...
vim.cmd.vnoremap('@ :norm @')

-- toggle quickfix
vim.keymap.set('n', '<leader>q', function()
  local qf_window_id = vim.fn.getqflist({ winid = 0 }).winid
  -- window id > 0 means that the window is open
  local qf_open = qf_window_id > 0
  if qf_open then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end)

-- open changed buffers in quickfix
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
    print('no changed buffers')
    return
  end
  vim.fn.setqflist(changed_buffers)
  vim.cmd.copen()
  vim.cmd.cfirst()
end)

-- Go
vim.keymap.set('n', '<leader>gt', function()
  if vim.bo.filetype ~= 'go' then
    print('not in a Go file')
    return
  end

  local filepath = vim.api.nvim_buf_get_name(0)
  local dirname = vim.fs.dirname(filepath)
  local basename = vim.fs.basename(filepath)

  local new_basename
  if basename:match('_test') then
    new_basename = basename:match('^(.+)_test%.go$') .. '.go'
  else
    new_basename = basename:match('^(.+)%.go$') .. '_test.go'
  end

  vim.cmd.edit(dirname .. '/' .. new_basename)
end)
