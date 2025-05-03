vim.opt_local.formatoptions:remove('t')
vim.bo.formatprg = 'black --stdin-filename=% --quiet -'
vim.bo.textwidth = 100
