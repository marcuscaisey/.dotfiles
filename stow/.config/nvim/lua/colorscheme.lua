local ok, nord = pcall(require, 'nord')
if not ok then
    return
end

nord.setup({
    ---@param colors Nord.Palette
    on_highlights = function(highlights, colors)
        for _, kind in ipairs(vim.lsp.protocol.CompletionItemKind) do
            highlights['LspKind' .. kind] = { link = 'BlinkCmpKind' .. kind }
        end
		highlights.TreesitterContext = { fg = highlights.Normal.fg, bg = colors.polar_night.bright }
    end,
})

vim.cmd.colorscheme('nord')
