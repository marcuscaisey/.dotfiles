vim.api.nvim_create_autocmd('FileType', {
    desc = 'Start treesitter highlighting',
    group = vim.api.nvim_create_augroup('treesitter.highlight_start', {}),
    command = 'lua pcall(vim.treesitter.start)',
})
