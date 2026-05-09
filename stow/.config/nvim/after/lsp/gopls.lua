---@type vim.lsp.Config
return {
    settings = {
        gopls = {
            semanticTokens = true,
            semanticTokenTypes = { string = false },
        },
    },
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('gopls.organize_imports_' .. bufnr, {}),
            buffer = bufnr,
            desc = 'Run gopls source.organizeImports code action',
            callback = function()
                local params = vim.lsp.util.make_range_params(0, client.offset_encoding) ---@type lsp.CodeActionParams
                params.context = { only = { 'source.organizeImports' }, diagnostics = {} }
                client:request('textDocument/codeAction', params, function(err, result)
                    if err or not result then
                        return
                    end
                    for _, code_action in pairs(result) do
                        if code_action.edit then
                            vim.lsp.util.apply_workspace_edit(code_action.edit, client.offset_encoding)
                        end
                    end
                end, bufnr)
            end,
        })
        -- This doesn't work very well sometimes.
        client.server_capabilities.semanticTokensProvider.range = false
    end,
}
