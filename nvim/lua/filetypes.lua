-- Only use lua filetype detection
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.filetype.add {
  extension = {
    build_defs = 'please',
    plz = 'please',
  },
  filename = {
    ['BUILD'] = 'please',
  },
}

vim.cmd 'augroup two_space_tabs'
vim.cmd '  autocmd!'
vim.cmd '  autocmd FileType lua,javascript,json setlocal tabstop=2 shiftwidth=2'
vim.cmd 'augroup END'

vim.cmd 'augroup textwidths'
vim.cmd '  autocmd!'
vim.cmd '  autocmd FileType python setlocal textwidth=100'
vim.cmd '  autocmd FileType go,lua setlocal textwidth=120'
vim.cmd 'augroup END'
