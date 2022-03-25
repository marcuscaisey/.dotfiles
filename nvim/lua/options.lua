vim.cmd 'colorscheme gruvbox'
vim.o.clipboard = 'unnamed'
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.hidden = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.pumheight = 10
vim.o.scrolloff = 10
vim.o.shiftwidth = 4
vim.o.showmode = false
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.updatetime = 100

vim.g.did_load_filetypes = 0
vim.g.do_filetype_lua = 1
vim.g.mapleader = ' '
vim.g.netrw_banner = 0
vim.g.netrw_list_hide = vim.fn['netrw_gitignore#Hide']() .. '\\|\\(^\\|\\s\\s\\)\\zs\\.\\S\\+'

vim.filetype.add {
  extension = {
    build_defs = 'please',
    plz = 'please',
  },
  filename = {
    ['BUILD'] = 'please',
  },
}

require('file_types').setup {
  lua = {
    tab_size = 2,
    text_width = 120,
    format_on_save = true,
  },
  javascript = {
    tab_size = 2,
  },
  json = {
    tab_size = 2,
  },
  jsonc = {
    tab_size = 2,
  },
  python = {
    text_width = 100,
    format_on_save = true,
  },
  go = {
    text_width = 120,
    indent_with_tabs = true,
    format_on_save = true,
  },
  proto = {
    text_width = 100,
    format_on_save = true,
  },
}
