vim.bo.textwidth = 100

-- Remove default tree-sitter based outline mapping so we can use one based on LSP instead
vim.keymap.del('n', 'gO', { buf = 0 })
