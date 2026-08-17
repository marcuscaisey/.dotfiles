---@type vim.lsp.Config
return {
    ---@type lspconfig.settings.jdtls
    settings = {
        java = {
            referencesCodeLens = { enabled = false },
        },
    },
}
