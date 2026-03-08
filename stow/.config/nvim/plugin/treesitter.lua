vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('treesitter_highlight_start', {}),
    desc = 'Start treesitter highlighting',
    command = 'lua pcall(vim.treesitter.start)',
})
