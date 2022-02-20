local telescope = require 'telescope.builtin'
local neoformat = require 'plugins.neoformat'
local gitsigns = require 'gitsigns.actions'
local nvim_tree = require 'nvim-tree'

vim.g.mapleader = ' '

local default_opts = { silent = true }

vim.keymap.set('i', 'jj', '<esc>', default_opts)

vim.keymap.set('n', 'gk', 'gg', default_opts)
vim.keymap.set('v', 'gk', 'gg', default_opts)
vim.keymap.set('n', 'gj', 'G', default_opts)
vim.keymap.set('v', 'gj', 'G', default_opts)
vim.keymap.set('n', 'gh', '^', default_opts)
vim.keymap.set('v', 'gh', '^', default_opts)
vim.keymap.set('n', 'gl', '$', default_opts)
vim.keymap.set('v', 'gl', 'g_', default_opts)

vim.keymap.set('n', '<c-j>', '<c-w>j', default_opts)
vim.keymap.set('n', '<c-k>', '<c-w>k', default_opts)
vim.keymap.set('n', '<c-l>', '<c-w>l', default_opts)
vim.keymap.set('n', '<c-h>', '<c-w>h', default_opts)
vim.keymap.set('n', '<c-w>j', '<c-w>J', default_opts)
vim.keymap.set('n', '<c-w>k', '<c-w>K', default_opts)
vim.keymap.set('n', '<c-w>l', '<c-w>L', default_opts)
vim.keymap.set('n', '<c-w>h', '<c-w>H', default_opts)
vim.keymap.set('n', '<c-w><', '<c-w>5<', default_opts)
vim.keymap.set('n', '<c-w>>', '<c-w>5>', default_opts)
vim.keymap.set('n', '<c-w>-', '<c-w>5-', default_opts)
vim.keymap.set('n', '<c-w>=', '<c-w>5+', default_opts)
vim.keymap.set('n', '<c-w>e', '<c-w>=', default_opts)

vim.keymap.set('n', 'Y', 'y$', default_opts)

vim.keymap.set('i', 'II', '<esc>I', default_opts)
vim.keymap.set('i', 'AA', '<esc>A', default_opts)

vim.keymap.set('n', '<leader>cd', '<cmd>cd %:h<cr>:pwd<cr>', default_opts)

-- nvim-bufferline.lua
vim.keymap.set('n', 'L', '<cmd>BufferLineCycleNext<cr>', default_opts)
vim.keymap.set('n', 'H', '<cmd>BufferLineCyclePrev<cr>', default_opts)

-- nvim-tree.lua
vim.keymap.set('n', '<c-n>', nvim_tree.toggle, default_opts)

-- telescope.nvim
vim.keymap.set('n', '<c-p>', telescope.find_files, default_opts)
vim.keymap.set('n', '<c-b>', telescope.buffers, default_opts)
vim.keymap.set('n', '<c-f>', telescope.current_buffer_fuzzy_find, default_opts)
vim.keymap.set('n', '<c-g>', telescope.live_grep, default_opts)
vim.keymap.set('n', '<c-s>', telescope.lsp_document_symbols, default_opts)
vim.keymap.set('n', 'gd', telescope.lsp_definitions, default_opts)
vim.keymap.set('n', 'ge', telescope.lsp_references, default_opts)
vim.keymap.set('n', '<leader>ht', telescope.help_tags, default_opts)
vim.keymap.set('n', '<leader>of', telescope.oldfiles, default_opts)
vim.keymap.set('n', '<leader>t', telescope.builtin, default_opts)
vim.keymap.set('n', '<leader>r', telescope.resume, default_opts)

-- lsp
vim.keymap.set('n', 'K', vim.lsp.buf.hover, default_opts)
vim.keymap.set('n', 'dK', vim.diagnostic.open_float, default_opts)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, default_opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, default_opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, default_opts)
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next { severity = { min = vim.diagnostic.severity.WARN } }
end, default_opts)
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev { severity = { min = vim.diagnostic.severity.WARN } }
end, default_opts)

-- neoformat
vim.keymap.set('n', '<leader>fm', '<cmd>Neoformat<cr>', default_opts)
vim.keymap.set('n', '<leader>ft', neoformat.toggle_auto_neoformatting, default_opts)

-- vim-fugitive
vim.keymap.set('n', '<leader>gb', '<cmd>:Git blame<cr>', default_opts)

-- gitsigns.nvim
vim.keymap.set('n', ']c', gitsigns.next_hunk, default_opts)
vim.keymap.set('n', '[c', gitsigns.prev_hunk, default_opts)
vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, default_opts)
vim.keymap.set('v', '<leader>hr', function()
  gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
end, default_opts)
vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer, default_opts)
vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, default_opts)
vim.keymap.set('n', '<leader>td', gitsigns.toggle_deleted, default_opts)
vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk, default_opts)
