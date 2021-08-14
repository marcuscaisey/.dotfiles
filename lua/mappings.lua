local g = vim.g
local fn = vim.fn
local api = vim.api
local cmd = vim.cmd
local map = vim.api.nvim_set_keymap

cmd('autocmd BufWritePost mappings.lua source <afile>')

g.mapleader = ' '

map('i', 'jj', '<esc>', {noremap = true})

map('n', 'gk', 'gg', {noremap = true})
map('v', 'gk', 'gg', {noremap = true})
map('n', 'gj', 'G', {noremap = true})
map('v', 'gj', 'G', {noremap = true})
map('n', 'gh', '^', {noremap = true})
map('v', 'gh', '^', {noremap = true})
map('n', 'gl', '$', {noremap = true})
map('v', 'gl', 'g_', {noremap = true})

map('n', '<c-j>', '<c-w>j', {noremap = true})
map('n', '<c-k>', '<c-w>k', {noremap = true})
map('n', '<c-l>', '<c-w>l', {noremap = true})
map('n', '<c-h>', '<c-w>h', {noremap = true})
map('n', '<c-w>j', '<c-w>J', {noremap = true})
map('n', '<c-w>k', '<c-w>K', {noremap = true})
map('n', '<c-w>l', '<c-w>L', {noremap = true})
map('n', '<c-w>h', '<c-w>H', {noremap = true})
map('n', '<c-w><', '<c-w>5<', {noremap = true})
map('n', '<c-w>>', '<c-w>5>', {noremap = true})
map('n', '<c-w>-', '<c-w>5-', {noremap = true})
map('n', '<c-w>=', '<c-w>5+', {noremap = true})
map('n', '<c-w>e', '<c-w>=', {noremap = true})

map('n', 'Y', 'y$', {noremap = true})

map('i', 'II', '<esc>I', {noremap = true})
map('i', 'AA', '<esc>A', {noremap = true})

map('v', '<leader>s', '"9y:%s/<c-r>9/', {noremap = true})

-- nvim-bufferline.lua
map('n', 'L', ':BufferLineCycleNext<cr>', {noremap = true, silent = true})
map('n', 'H', ':BufferLineCyclePrev<cr>', {noremap = true, silent = true})

-- vim-easy-align
map('n', 'ga', '<Plug>(EasyAlign)', {silent = true})
map('x', 'ga', '<Plug>(EasyAlign)', {silent = true})

-- vim-fugitive
-- nmap <silent> <expr> <leader>gb &filetype ==# 'fugitiveblame' ? 'gq' : ':Gblame<cr>'

-- nvim-tree.lua
map('n', '<c-n>', ':NvimTreeToggle<cr>', {noremap = true, silent = true})

-- telescope.nvim
map('n', '<c-p>', ':Telescope find_files<cr>', {noremap = true, silent = true})
map('n', '<c-b>', ':Telescope buffers<cr>', {noremap = true, silent = true})
map('n', '<c-f>', ':Telescope current_buffer_fuzzy_find<cr>', {noremap = true, silent = true})
map('n', '<c-g>', ':Telescope live_grep<cr>', {noremap = true, silent = true})
map('n', '<leader>ht', ':Telescope help_tags<cr>', {noremap = true, silent = true})

-- nvim-compe
map('i', '<c-space>', 'compe#complete()', {noremap = true, silent = true, expr = true})
map('i', '<cr>', [[compe#confirm('<cr>')]], {noremap = true, silent = true, expr = true})
map('i', '<tab>', [[pumvisible() ? compe#close('<tab>') : v:lua.tab_out()]], {noremap = true, silent = true, expr = true})

-- Returns either <tab> or <right>, depending on whether we need to tab out of
-- a pair of brackets or not.
function tab_out()
  if should_tab_out() then
    return api.nvim_replace_termcodes('<right>', false, false, true)
  else
    return api.nvim_replace_termcodes('<tab>', false, false, true)
  end
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
