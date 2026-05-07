-- This is set to GetPhpIndent() in the default indent/php.vim script
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
