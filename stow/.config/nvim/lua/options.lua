local filetypes = require('filetypes')

vim.o.clipboard = 'unnamed'
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.hidden = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.lazyredraw = true
vim.o.mouse = 'a'
vim.o.number = true
vim.o.pumheight = 10
vim.o.relativenumber = true
vim.o.scrolloff = 10
vim.o.shiftwidth = 4
vim.o.shortmess = vim.o.shortmess .. 'S'
vim.o.diffopt = vim.o.diffopt .. ',linematch:60'
vim.o.showmode = false
vim.o.signcolumn = 'yes:2'
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.wrapscan = false
vim.o.updatetime = 100

filetypes.setup({
  lua = { tab_size = 2, text_width = 120 },
  javascript = { tab_size = 2 },
  typescript = { tab_size = 2 },
  json = { tab_size = 2 },
  jsonc = { tab_size = 2 },
  python = { text_width = 100 },
  go = { text_width = 120, indent_with_tabs = true },
  proto = { text_width = 100 },
  query = { tab_size = 2 },
  zsh = { tab_size = 2 },
  sh = { tab_size = 2 },
  markdown = { text_width = 100, auto_wrap = true },
  html = { tab_size = 2 },
  sql = { tab_size = 2, text_width = 100 },
  scheme = { tab_size = 2 },
  please = { text_width = 120 },
})

vim.filetype.add({
  extension = {
    vifm = 'vim',
  },
  filename = {
    vifmrc = 'vim',
  },
})
