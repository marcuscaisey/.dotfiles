vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('go.puku_format', {}),
    pattern = { '*.go' },
    desc = 'Run puku on saved file',
    callback = function(ev)
        if not vim.fs.root(ev.match, '.plzconfig') then
            return
        end
        vim.system({ 'puku', 'fmt', ev.match }, nil, function(res)
            local output = res.code == 0 and vim.trim(res.stdout) or vim.trim(res.stderr)
            if output ~= '' then
                vim.schedule(function()
                    vim.notify('puku: ' .. output, vim.log.levels.INFO)
                end)
            end
        end)
    end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('go.organize_imports_', {}),
    pattern = '*.go',
    desc = 'Run source.organizeImports code action on save',
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
