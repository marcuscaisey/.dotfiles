local ok, nord = pcall(require, 'nord')
if not ok then
    return
end

nord.setup({
    on_highlights = function(highlights)
        for _, kind in ipairs(vim.lsp.protocol.CompletionItemKind) do
            highlights['LspKind' .. kind] = { link = 'BlinkCmpKind' .. kind }
        end
    end,
})

vim.cmd.colorscheme('nord')
