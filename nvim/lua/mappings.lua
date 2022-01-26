local telescope = require 'telescope.builtin'
local neoformat = require 'plugins.neoformat'
local gitsigns = require 'gitsigns.actions'

vim.g.mapleader = ' '

local function map(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, { silent = true })
end

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

map('n', 'Y', 'y$')

map('i', 'II', '<esc>I')
map('i', 'AA', '<esc>A')

map('n', '<leader>cd', '<cmd>cd %:h<cr>:pwd<cr>')

-- nvim-bufferline.lua
map('n', 'L', '<cmd>BufferLineCycleNext<cr>')
map('n', 'H', '<cmd>BufferLineCyclePrev<cr>')

-- nvim-tree.lua
map('n', '<c-n>', '<cmd>NvimTreeToggle<cr>')

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

-- nvim-lspconfig
map('n', 'K', vim.lsp.buf.hover)
map('n', 'dK', vim.diagnostic.open_float)
map('n', '<leader>rn', vim.lsp.buf.rename)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '[d', vim.diagnostic.goto_prev)

-- neoformat
map('n', '<leader>fm', '<cmd>Neoformat<cr>')
map('n', '<leader>ft', neoformat.toggle_auto_neoformatting)

-- vim-fugitive
map('n', '<leader>gb', '<cmd>:Git blame<cr>')

-- gitsigns.nvim
map('n', ']c', gitsigns.next_hunk)
map('n', '[c', gitsigns.prev_hunk)
map({ 'n', 'v' }, '<leader>hs', gitsigns.stage_hunk)
map({ 'n', 'v' }, '<leader>hr', gitsigns.reset_hunk)
map('n', '<leader>hS', gitsigns.stage_buffer)
map('n', '<leader>hu', gitsigns.undo_stage_hunk)
map('n', '<leader>hR', gitsigns.reset_buffer)
map('n', '<leader>hp', gitsigns.preview_hunk)
map('n', '<leader>hb', function()
  gitsigns.blame_line { full = true }
end)
map('n', '<leader>tb', gitsigns.toggle_current_line_blame)
map('n', '<leader>hd', gitsigns.diffthis)
map('n', '<leader>hD', function()
  gitsigns.diffthis '~'
end)
map('n', '<leader>td', gitsigns.toggle_deleted)
map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
