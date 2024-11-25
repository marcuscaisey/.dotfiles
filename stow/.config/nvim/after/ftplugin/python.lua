vim.opt_local.textwidth = 100
vim.opt_local.formatoptions:remove('t')
vim.opt_local.formatprg = 'black --stdin-filename=% --quiet -'
