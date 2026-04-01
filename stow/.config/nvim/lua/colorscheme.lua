local ok, catppuccin = pcall(require, 'catppuccin')
if not ok then
    return
end
local colors = require('catppuccin.utils.colors')

catppuccin.setup({
    integrations = {
        mason = true,
        native_lsp = {
            underlines = {
                errors = { 'undercurl' },
                hints = { 'undercurl' },
                warnings = { 'undercurl' },
                information = { 'undercurl' },
            },
        },
        nvim_surround = true,
        lsp_saga = true,
    },
    highlight_overrides = {
        mocha = function(palette)
            return {
                DiffChange = { bg = colors.darken(palette.blue, 0.15, palette.base) },
                IncSearch = { bg = palette.peach },
            }
        end,
    },
    custom_highlights = function()
        local highlights = {
            CurSearch = { link = 'IncSearch' },
        }
        for _, kind in ipairs(vim.lsp.protocol.CompletionItemKind) do
            highlights['LspKind' .. kind] = { link = 'BlinkCmpKind' .. kind }
        end
        return highlights
    end,
    flavour = 'mocha',
})

vim.cmd.colorscheme('catppuccin-nvim')
