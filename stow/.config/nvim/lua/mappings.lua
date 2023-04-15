vim.g.mapleader = ' '
vim.g.camelcasemotion_key = '<leader>'

vim.keymap.set('i', 'jj', '<esc>')

-- Jump to start / end of line / buffer with g(h|j|k|l)
vim.keymap.set({ 'n', 'v' }, 'gh', '^')
vim.keymap.set({ 'n', 'v' }, 'gj', 'G')
vim.keymap.set({ 'n', 'v' }, 'gk', 'gg')
vim.keymap.set('n', 'gl', '$')
vim.keymap.set('v', 'gl', 'g_')

-- Resize splits in increments of 5
vim.keymap.set('n', '<c-w><', '<c-w>5<')
vim.keymap.set('n', '<c-w>>', '<c-w>5>')
vim.keymap.set('n', '<c-w>-', '<c-w>5-')
vim.keymap.set('n', '<c-w>=', '<c-w>5+')

-- Keep current cursor line in center of buffer when jumping between search results
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- Keep current cursor line in center of buffer when scrolling window
vim.keymap.set('n', '<c-d>', '<c-d>zz')
vim.keymap.set('n', '<c-u>', '<c-u>zz')

-- Swap lines above / below with J or K in visual mode
vim.keymap.set('v', 'J', ":m '>+1<cr>gv", { silent = true })
vim.keymap.set('v', 'K', ":m '<-2<cr>gv", { silent = true })

-- Keep cursor in same position when joining lines
vim.keymap.set('n', 'J', 'mzJ`z')

-- <esc> to leave terminal mode
vim.keymap.set('t', '<esc>', '<c-\\><c-n>')

vim.keymap.set('n', '<leader>dt', vim.cmd.diffthis)
vim.keymap.set('n', '<leader>do', function()
  vim.cmd.diffoff({bang = true})
end)

-- Don't overwrite unnamed register when pasting in visual mode
vim.keymap.set('v', 'p', 'P')

-- Add to jumplist after relative line jumps
vim.keymap.set('n', 'j', function()
  if vim.v.count > 0 then
    vim.cmd.normal({ string.format("m'%sj", vim.v.count), bang = true })
    return
  end
  vim.cmd.normal({ 'j', bang = true })
end)
vim.keymap.set('n', 'k', function()
  if vim.v.count > 0 then
    vim.cmd.normal({ string.format("m'%sk", vim.v.count), bang = true })
    return
  end
  vim.cmd.normal({ 'k', bang = true })
end)

-- Jump between git conflict markers <<<<<<<, =======, >>>>>>> with ]n and [n
vim.keymap.set('n', ']n', function()
  vim.fn.search([[^\(<\{7}\|=\{7}\|>\{7}\)]], 'W')
end)
vim.keymap.set('n', '[n', function()
  vim.fn.search([[\(<\{7}\|=\{7}\|>\{7}\)]], 'bW')
end)

-- Yank current path relative to the git root
vim.keymap.set('n', '<leader>y', function()
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local filepath = vim.api.nvim_buf_get_name(0)
  local relative_filepath = filepath:gsub('^' .. git_root .. '/', '')
  vim.fn.setreg('"', relative_filepath)
  vim.fn.setreg('*', relative_filepath)
  print(string.format('Yanked %s', relative_filepath))
end)

-- When i use vim.keymap.set to create this, nothing appears in the command line when i trigger the mapping until i press another
-- key. Not sure why...
vim.cmd.vnoremap('@ :norm @')

-- Toggle quickfix window
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

vim.keymap.set('n', ']q', function()
  pcall(vim.cmd.cnext)
end)
vim.keymap.set('n', '[q', function()
  pcall(vim.cmd.cprev)
end)

-- Open unsaved buffers in quickfix window
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
end)

-- Open modified or untracked files in quickfix
vim.keymap.set('n', '<leader>gf', function()
  local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  local files = vim.fn.systemlist(
    string.format('git -C %s ls-files --modified --others --exclude-standard --full-name --deduplicate', git_root)
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
end)
