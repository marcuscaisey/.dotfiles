local telescope = require 'telescope.builtin'
local neoformat = require 'plugins.neoformat'
local gitsigns = require 'gitsigns.actions'
-- local neo_tree = require 'neo-tree'
local harpoon_ui = require 'harpoon.ui'
local map = require('utils.mappings').map

map('i', 'jj', '<esc>')

map('n', 'gk', 'gg')
map('v', 'gk', 'gg')
map('n', 'gj', 'G')
map('v', 'gj', 'G')
map('n', 'gh', '^')
map('v', 'gh', '^')
map('n', 'gl', '$')
map('v', 'gl', 'g_')

map('n', '<c-j>', '<c-w>j')
map('n', '<c-k>', '<c-w>k')
map('n', '<c-l>', '<c-w>l')
map('n', '<c-h>', '<c-w>h')
map('n', '<c-w>j', '<c-w>J')
map('n', '<c-w>k', '<c-w>K')
map('n', '<c-w>l', '<c-w>L')
map('n', '<c-w>h', '<c-w>H')
map('n', '<c-w><', '<c-w>5<')
map('n', '<c-w>>', '<c-w>5>')
map('n', '<c-w>-', '<c-w>5-')
map('n', '<c-w>=', '<c-w>5+')
map('n', '<c-w>e', '<c-w>=')

map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')

map('i', 'II', '<esc>I')
map('i', 'AA', '<esc>A')

map('n', '<leader>cd', '<cmd>cd %:h<cr>:pwd<cr>')

map('t', '<esc>', '<c-\\><c-n>')

-- toggle quickfix
map('n', '<leader>q', function()
  local qf_window_id = vim.fn.getqflist({ winid = 0 }).winid
  -- window id > 0 means that the window is open
  if qf_window_id > 0 then
    vim.cmd 'cclose'
  else
    vim.cmd 'copen'
  end
end)

-- open changed buffers in quickfix
map('n', '<leader>cb', function()
  -- filter buffers for changed property since bufmodified = 1 doesn't seem to filter out all unchanged buffers
  local changed_buffers = vim.tbl_filter(
    function(b)
      return b.changed == 1
    end,
    vim.fn.getbufinfo {
      bufmodified = 1,
    }
  )
  if #changed_buffers == 0 then
    print 'no changed buffers'
    return
  end
  vim.fn.setqflist(changed_buffers)
  vim.cmd 'copen'
  vim.cmd 'cfirst'
end)

-- open git changes in quickfix
map('n', '<leader>gc', function()
  local git_root = vim.trim(vim.fn.system 'git rev-parse --show-toplevel')
  local cwd = vim.fn.getcwd()

  local changed_files = vim.fn.systemlist 'git diff --numstat'
  local added_files = vim.fn.systemlist(string.format('git ls-files --others --exclude-standard %s', git_root))

  local qf_items = {}
  for _, line in pairs(changed_files) do
    -- lines are in the format $ADDED\t$DELETED\t$FILENAME
    local parts = vim.fn.split(line, '\t')
    local added = parts[1]
    local removed = parts[2]
    local absolute_filepath = git_root .. '/' .. parts[3]
    local relative_filepath = vim.trim(
      vim.fn.system(string.format('realpath --relative-to %s %s', cwd, absolute_filepath))
    )

    table.insert(qf_items, {
      filename = relative_filepath,
      text = string.format('+%s -%s', added, removed),
    })
  end
  for _, filename in pairs(added_files) do
    table.insert(qf_items, { filename = filename, text = 'added' })
  end

  if #qf_items == 0 then
    print 'no changed / added files'
    return
  end

  vim.fn.setqflist(qf_items)
  vim.cmd 'copen'
  vim.cmd 'cfirst'
end)

map('n', '<c-n>', function()
  vim.cmd 'Explore'
end)

-- telescope.nvim
map('n', '<c-p>', telescope.find_files)
map('n', '<c-b>', telescope.buffers)
map('n', '<c-f>', telescope.current_buffer_fuzzy_find)
map('n', '<c-g>', telescope.live_grep)
map('n', '<c-s>', telescope.lsp_document_symbols)
map('n', 'gd', telescope.lsp_definitions)
map('n', 'ge', telescope.lsp_references)
map('n', '<leader>ht', telescope.help_tags)
map('n', '<leader>of', telescope.oldfiles)
map('n', '<leader>t', telescope.builtin)
map('n', '<leader>r', telescope.resume)

-- lsp
map('n', 'K', vim.lsp.buf.hover)
map('n', 'dK', vim.diagnostic.open_float)
map('n', '<leader>rn', vim.lsp.buf.rename)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']e', function()
  vim.diagnostic.goto_next { severity = { min = vim.diagnostic.severity.WARN } }
end)
map('n', '[e', function()
  vim.diagnostic.goto_prev { severity = { min = vim.diagnostic.severity.WARN } }
end)

-- neoformat
map('n', '<leader>fm', '<cmd>Neoformat<cr>')
map('n', '<leader>ft', neoformat.toggle_auto_neoformatting)

-- vim-fugitive
map('n', '<leader>gb', '<cmd>:Git blame<cr>')

-- gitsigns.nvim
map('n', ']c', gitsigns.next_hunk)
map('n', '[c', gitsigns.prev_hunk)
map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
map('n', '<leader>hS', gitsigns.stage_buffer)
map('n', '<leader>hu', gitsigns.undo_stage_hunk)
map({ 'n', 'v' }, '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>')
map('n', '<leader>hR', gitsigns.reset_buffer)
map('n', '<leader>hp', gitsigns.preview_hunk)
map('n', '<leader>td', gitsigns.toggle_deleted)
map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)

-- harpoon
map('n', '<leader>ha', require('harpoon.mark').add_file)
map('n', '<leader>hh', harpoon_ui.toggle_quick_menu)
for n = 1, 4 do
  map('n', string.format('<leader>%d', n), function()
    harpoon_ui.nav_file(n)
  end)
end
