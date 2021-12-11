local o = vim.o
local cmd = vim.cmd
local g = vim.g

cmd('autocmd BufWritePost init.lua source <afile>')

require 'plugins.packer'
require 'mappings'

--------------------------------------------------------------------------------
--                                  options
--------------------------------------------------------------------------------
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
o.swapfile =  false
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


--------------------------------------------------------------------------------
--                                    misc
--------------------------------------------------------------------------------
-- Jump to last position when opening a file
cmd([[autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]])

-- Trim trailing whitespace on write
cmd([[autocmd BufWritePre * if expand('%:e') !=# 'diff' | %s/\s\+$//e | endif]])

-- Use 2 space tabs for lua
cmd('autocmd FileType lua,javascript set tabstop=2 shiftwidth=2')

-- Set file type as bazel for build_defs files
cmd('autocmd BufNewFile,BufRead *.build_defs set filetype=bzl')

-- Don't comment lines after o/O
cmd('autocmd BufEnter * set formatoptions-=o')

cmd('autocmd BufRead,BufNewFile BUILD,*.build_defs,*.build_def,*.build set filetype=please')
