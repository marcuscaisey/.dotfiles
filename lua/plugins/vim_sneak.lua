local g = vim.g
local cmd = vim.cmd

cmd('autocmd ColorScheme * highlight! link Sneak IncSearch')
g['sneak#use_ic_scs'] = 1
