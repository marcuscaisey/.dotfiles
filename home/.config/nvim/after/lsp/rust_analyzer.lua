---@type vim.lsp.Config
return {
    ---@type lspconfig.settings.rust_analyzer
    settings = {
        ['rust-analyzer'] = {
            lens = { enable = false }
        }
    }
}
