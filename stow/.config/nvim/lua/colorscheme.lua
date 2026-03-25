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
    color_overrides = {
        mocha = {
            base = '#000000',
            mantle = '#010101',
            crust = '#020202',
        },
    },
    highlight_overrides = {
        mocha = function(palette)
            return {
                DiffChange = { bg = colors.darken(palette.blue, 0.15, palette.base) },
                IncSearch = { bg = palette.peach },
            }
        end,
    },
    custom_highlights = {
        CurSearch = { link = 'IncSearch' },
    },
    flavour = 'mocha',
})

vim.cmd.colorscheme('catppuccin')

for _, kind in ipairs(vim.lsp.protocol.CompletionItemKind) do
    vim.api.nvim_set_hl(0, 'LspKind' .. kind, { link = 'BlinkCmpKind' .. kind })
end
