vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.textwidth = 120
-- If this is not set, it gets automatically overridden to v:lua.vim.lsp.formatexpr() by Neovim when the Lua language
-- server attaches which breaks formatting with gq.
vim.opt_local.formatexpr = ' '
