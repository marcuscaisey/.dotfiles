local telescope = require 'telescope.builtin'
local neoformat = require 'plugins.neoformat'
local gitsigns = require 'gitsigns.actions'
local neo_tree = require 'neo-tree'

vim.g.mapleader = ' '

-- light wrapper around vim.keymap.set which sets default options
local function map(mode, lhs, rhs, opts)
  local default_opts = { silent = true }

  opts = opts or {}
  local merged_opts = default_opts
  for k, v in pairs(opts) do
    merged_opts[k] = v
  end

  vim.keymap.set(mode, lhs, rhs, merged_opts)
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

-- neo-tree.nvim
map('n', '<c-n>', function()
  local toggle_if_open = true
  neo_tree.reveal_in_split('filesystem', toggle_if_open)
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
map('n', '<leader>hr', gitsigns.reset_hunk)
map('v', '<leader>hr', function()
  gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
end)
map('n', '<leader>hR', gitsigns.reset_buffer)
map('n', '<leader>hp', gitsigns.preview_hunk)
map('n', '<leader>td', gitsigns.toggle_deleted)
map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
