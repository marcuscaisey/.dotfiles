local o = vim.o
local cmd = vim.cmd

cmd('packadd dracula_pro')
cmd('colorscheme dracula_pro')
o.clipboard = 'unnamed'
o.cursorline = true
o.expandtab = true
o.hidden = true
o.ignorecase = true
o.inccommand = 'nosplit'
o.mouse = 'a'
o.hlsearch = false
o.showmode = false
o.swapfile = false
o.number = true
o.scrolloff = 5
o.shiftwidth = 4
o.showtabline = 2
o.signcolumn = 'yes'
o.smartcase = true
o.splitbelow = true
o.splitright = true
o.tabstop = 4
o.termguicolors = true
o.updatetime = 100
