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

local two_space_tab_types = {
  'lua',
  'javascript',
}
vim.cmd(string.format(
  [[
  augroup two_space_tabs
    autocmd!
    autocmd FileType %s set tabstop=2 shiftwidth=2
  augroup END
]],
  table.concat(two_space_tab_types, ',')
))
