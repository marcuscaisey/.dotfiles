vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'Run source.organizeImports code action on save',
    group = vim.api.nvim_create_augroup('go.organize_imports_', {}),
    pattern = '*.go',
    callback = function()
        vim.lsp.buf.code_action({
            context = {
                only = { 'source.organizeImports' },
                diagnostics = {},
            },
            apply = true,
        })
    end,
})
