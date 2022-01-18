-- Jump to last position when opening a file
vim.cmd [[autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]

-- Trim trailing whitespace on write
vim.cmd [[autocmd BufWritePre * if expand('%:e') !=# 'diff' | %s/\s\+$//e | endif]]

-- Don't comment lines after o/O
vim.cmd 'autocmd BufEnter * set formatoptions-=o'

-- Highlight yanked text
vim.cmd [[
  augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=1000 }
  augroup END
]]
