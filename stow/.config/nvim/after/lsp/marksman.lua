---@type vim.lsp.Config
return {
    on_attach = function(client)
        client.server_capabilities.codeLensProvider = nil
    end,
}
