local cmd = vim.cmd
local g = vim.g

cmd [[autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif]]
g.oscyank_silent = true
