vim.cmd 'augroup misc'
vim.cmd '  autocmd!'
-- Jump to last position when opening a file
vim.cmd [[ autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
-- Trim trailing whitespace on write
vim.cmd [[ autocmd BufWritePre * if expand('%:e') !=# 'diff' | %s/\s\+$//e | endif]]
-- Highlight yanked text
vim.cmd [[ autocmd TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=1000 }]]
vim.cmd 'augroup END'

vim.cmd 'augroup wollemi'
vim.cmd '  autocmd!'
-- Run wollemi on parent directory of go files on save (directory passed as relative path)
vim.cmd "  autocmd BufWritePost *.go silent execute '!wollemi --log fatal gofmt' fnamemodify(expand('%:h'), ':.')"
vim.cmd 'augroup END'
