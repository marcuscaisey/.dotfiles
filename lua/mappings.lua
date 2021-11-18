local g = vim.g
local fn = vim.fn
local api = vim.api
local cmd = vim.cmd

cmd('autocmd BufWritePost mappings.lua source <afile>')

g.mapleader = ' '

local function map(mode, lhs, rhs, opts)
  local options = {
    noremap = true,
    silent = true,
  }
  if opts then
    for k, v in pairs(opts) do options[k] = v end
  end
  api.nvim_set_keymap(mode, lhs, rhs, options)
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

map('v', '<leader>s', '"9y:%s/<c-r>9/')

-- nvim-bufferline.lua
map('n', 'L', '<cmd>BufferLineCycleNext<cr>')
map('n', 'H', '<cmd>BufferLineCyclePrev<cr>')

-- vim-easy-align
map('n', 'ga', '<Plug>(EasyAlign)', {noremap = false})
map('x', 'ga', '<Plug>(EasyAlign)', {noremap = false})

-- vim-fugitive
-- nmap <silent> <expr> <leader>gb &filetype ==# 'fugitiveblame' ? 'gq' : ':Gblame<cr>'

-- nvim-tree.lua
map('n', '<c-n>', '<cmd>NvimTreeToggle<cr>')

-- telescope.nvim
map('n', '<c-p>', '<cmd>Telescope find_files<cr>')
map('n', '<c-b>', '<cmd>Telescope buffers<cr>')
map('n', '<c-f>', '<cmd>Telescope current_buffer_fuzzy_find<cr>')
map('n', '<c-g>', '<cmd>Telescope live_grep<cr>')
map('n', '<c-s>', '<cmd>Telescope lsp_document_symbols<cr>')
map('n', 'gd', '<cmd>Telescope lsp_definitions<cr>')
map('n', 'ge', '<cmd>Telescope lsp_references<cr>')
map('n', '<leader>ht', '<cmd>Telescope help_tags<cr>')

-- nvim-lspconfig
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
map('n', 'dK', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>')
map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')
map('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<cr>')
map('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>')

-- neoformat
map('n', '<leader>fm', '<cmd>Neoformat<cr>')

-- symbols-outline.nvim
map('n', '<leader>o', '<cmd>SymbolsOutline<cr>')
