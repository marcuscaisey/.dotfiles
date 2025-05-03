vim.loader.enable()

vim.g.mapleader = ' '

vim.g.loaded_matchit = 1

---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function() end

require('colorscheme').setup()
