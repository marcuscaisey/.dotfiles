---@type vim.lsp.Config
return {
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = nil
        client.server_capabilities.documentRangeFormattingProvider = nil
        client.server_capabilities.documentOnTypeFormattingProvider = nil
    end,
}
