-- Jump to last position when opening a file
vim.cmd [[autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]

-- Trim trailing whitespace on write
vim.cmd [[autocmd BufWritePre * if expand('%:e') !=# 'diff' | %s/\s\+$//e | endif]]

-- Use 2 space tabs for lua
vim.cmd 'autocmd FileType lua,javascript set tabstop=2 shiftwidth=2'

-- Set file type as bazel for build_defs files
vim.cmd 'autocmd BufNewFile,BufRead *.build_defs set filetype=bzl'

-- Don't comment lines after o/O
vim.cmd 'autocmd BufEnter * set formatoptions-=o'

-- Set filetype as please in BUILD files
vim.cmd 'autocmd BufRead,BufNewFile BUILD,*.build_defs,*.build_def,*.build set filetype=please'

-- Highlight yanked text
vim.cmd [[
augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=1000 }
augroup END
]]
