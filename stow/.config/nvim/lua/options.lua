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

vim.filetype.add({
  extension = {
    vifm = 'vim',
  },
  filename = {
    vifmrc = 'vim',
    ['new-commit'] = 'gitcommit',
  },
})
