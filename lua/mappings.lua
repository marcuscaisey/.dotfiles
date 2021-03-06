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
map('n', 'ge', '<cmd>Telescope lsp_references<cr>')
map('n', '<leader>ht', '<cmd>Telescope help_tags<cr>')

-- nvim-compe
map('i', '<c-space>', 'compe#complete()', {expr = true})
map('i', '<cr>', [[compe#confirm('<cr>')]], {expr = true})
map('i', '<tab>', [[pumvisible() ? compe#close('<tab>') : v:lua.tab_out()]], {expr = true})

-- Returns either <tab> or <right>, depending on whether we need to tab out of
-- a pair of brackets or not.
function tab_out()
  if should_tab_out() then
    return replace_termcodes('<right>')
  else
    return replace_termcodes('<tab>')
  end
end

function replace_termcodes(s)
  return api.nvim_replace_termcodes(s, false, false, true)
end

-- Check if we should tab out of a pair of brackets / quotes. Returns true if
-- the next character is a:
-- - closing bracket
-- - quote and we're inside a pair of them
function should_tab_out()
  local brackets = {
    [')'] = true,
    [']'] = true,
    ['}'] = true,
  }
  local quotes = {
    ["'"] = true,
    ['"'] = true,
    ['`'] = true
  }

  local line = fn.getline('.')
  local col = fn.col('.')
  local next_char = line:sub(col, col)

  if quotes[next_char] then
    local preceding_chars = line:sub(1, col - 1)
    num_preceding_quotes = select(2, preceding_chars:gsub(next_char, ''))
    -- if odd number of preceding quotes, then we're currently inside a pair
    return num_preceding_quotes % 2 == 1
  end
  return brackets[next_char] == true
end

-- nvim-lspconfig
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
map('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>')
