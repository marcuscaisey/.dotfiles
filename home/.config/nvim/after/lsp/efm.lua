local languages = {
}

---@type vim.lsp.Config
return {
    filetypes = vim.tbl_keys(languages),
    init_options = { documentFormatting = true },
    settings = { languages = languages },
}
