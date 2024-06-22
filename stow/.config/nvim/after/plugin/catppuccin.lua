local ok, catppuccin = pcall(require, 'catppuccin')
if not ok then
  return
end
local colors = require('catppuccin.utils.colors')

catppuccin.setup({
  flavour = 'mocha',
  color_overrides = {
    mocha = {
      base = '#000000',
    },
  },
  highlight_overrides = {
    mocha = function(palette)
      return {
        LualineCwd = { fg = palette.surface2, bg = palette.mantle },
        NormalFloat = { fg = palette.overlay2, bg = palette.surface0 },
        DiffChange = { bg = colors.darken(palette.blue, 0.15, palette.base) },
        VertSplit = { link = 'FloatBorder' },
        CopilotSuggestion = { fg = palette.overlay2 },
      }
    end,
  },
  integrations = {
    ---@diagnostic disable-next-line: missing-fields
    native_lsp = {
      underlines = {
        errors = { 'undercurl' },
        hints = { 'undercurl' },
        warnings = { 'undercurl' },
        information = { 'undercurl' },
      },
    },
    treesitter_context = true,
  },
})
vim.cmd.colorscheme('catppuccin')
