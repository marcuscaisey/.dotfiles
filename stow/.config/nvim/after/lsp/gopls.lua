---@type vim.lsp.Config
return {
    settings = {
        gopls = {
            semanticTokens = true,
            semanticTokenTypes = { string = false },
        },
    },
    on_attach = function(client)
        -- This doesn't work very well sometimes.
        client.server_capabilities.semanticTokensProvider.range = false
    end,
}
