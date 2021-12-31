local o = vim.o
local cmd = vim.cmd

cmd 'packadd dracula_pro'
cmd 'colorscheme dracula_pro_van_helsing'
o.clipboard = 'unnamed'
o.cursorline = true
o.expandtab = true
o.hidden = true
o.hlsearch = false
o.ignorecase = true
o.inccommand = 'nosplit'
o.mouse = 'a'
o.number = true
o.pumheight = 10
o.scrolloff = 5
o.shiftwidth = 4
o.showmode = false
o.showtabline = 2
o.signcolumn = 'yes'
o.smartcase = true
o.splitbelow = true
o.splitright = true
o.swapfile = false
o.tabstop = 4
o.termguicolors = true
o.updatetime = 100
