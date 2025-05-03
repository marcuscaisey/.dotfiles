vim.opt_local.formatoptions:remove('o')
vim.bo.formatprg = 'stylua --stdin-filepath=% -'
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.textwidth = 120
