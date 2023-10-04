vim.opt_local.textwidth = 100
-- If this is not set, it gets automatically overridden to v:lua.vim.lsp.formatexpr() by Neovim when the Python language
-- server attaches which breaks formatting with gq.
vim.opt_local.formatexpr = ' '
vim.opt_local.formatoptions:remove('t')
