local filetypes = require('filetypes')

vim.o.clipboard = 'unnamed'
vim.o.cursorline = true
vim.o.colorcolumn = '+1'
vim.o.diffopt = vim.o.diffopt .. ',linematch:60'
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
vim.o.showmode = false
vim.o.signcolumn = 'yes:2'
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.updatetime = 100
vim.opt.formatoptions:append('n')

filetypes.setup({
  go = { text_width = 120, indent_with_tabs = true },
  html = { tab_size = 2 },
  javascript = { tab_size = 2 },
  json = { tab_size = 2 },
  jsonc = { tab_size = 2 },
  lua = { tab_size = 2, text_width = 120 },
  markdown = { text_width = 100, auto_wrap = true },
  please = { text_width = 120 },
  proto = { text_width = 100 },
  python = { text_width = 100 },
  query = { tab_size = 2 },
  scheme = { tab_size = 2 },
  sh = { text_width = 120, tab_size = 2 },
  sql = { tab_size = 2, text_width = 100 },
  typescript = { tab_size = 2 },
  zsh = { tab_size = 2 },
})

vim.filetype.add({
  extension = {
    vifm = 'vim',
  },
  filename = {
    vifmrc = 'vim',
    ['new-commit'] = 'gitcommit',
  },
})

vim.g.clipboard = {
  name = 'tmux',
  copy = {
    ['+'] = 'tmux load-buffer -w -',
    ['*'] = 'tmux load-buffer -w -',
  },
  paste = {
    ['+'] = 'tmux save-buffer -',
    ['*'] = 'tmux save-buffer -',
  },
}
