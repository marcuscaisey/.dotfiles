local g = vim.g
local cmd = vim.cmd
local map = vim.api.nvim_set_keymap

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

-- nvim-bufferline.lua
map('n', 'L', ':BufferLineCycleNext<cr>', {noremap = true, silent = true})
map('n', 'H', ':BufferLineCyclePrev<cr>', {noremap = true, silent = true})

-- vim-easy-align
map('n', 'ga', '<Plug>(EasyAlign)', {silent = true})
map('x', 'ga', '<Plug>(EasyAlign)', {silent = true})

-- vim-fugitive
-- nmap <silent> <expr> <leader>gb &filetype ==# 'fugitiveblame' ? 'gq' : ':Gblame<cr>'

-- Tab moves the cursor out of paired characters
map('i', '<tab>', "ShouldTabOut() ? '<right>' : '<tab>'", {silent = true, expr = true, noremap = true})

-- Return true if character under the cursor is either:
-- - a closing bracket
-- - a quote and there are an odd number of preceding quotes (ie the quote is
--   a closing quote)
cmd([[
function! ShouldTabOut()
  let brackets = [')', ']', '}']
  let quotes = ["'",  '"',  '`']

  let preceding_chars = getline('.')[:col('.') - 2]
  let current_char = getline('.')[col('.') - 1]

  if index(quotes, current_char) != -1
    let num_preceding_quotes = strlen(preceding_chars) - strlen(substitute(preceding_chars, current_char, '', 'g'))
    return num_preceding_quotes % 2 == 1
  else
    return index(brackets, current_char) != -1
  endif
endfunction
]])

-- nvim-tree.lua
map('n', '<c-n>', ':NvimTreeToggle<cr>', {noremap = true, silent = true})

-- telescope.nvim
map('n', '<c-p>', ':Telescope find_files previewer=false theme=get_dropdown<cr>', {noremap = true, silent = true})
map('n', '<c-b>', ':Telescope buffers previewer=false theme=get_dropdown<cr>', {noremap = true, silent = true})
