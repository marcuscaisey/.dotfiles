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
        IncSearch = { bg = palette.peach },
        NormalFloat = { fg = palette.overlay2, bg = palette.surface0 },
        DiffChange = { bg = colors.darken(palette.blue, 0.15, palette.base) },
        VertSplit = { link = 'FloatBorder' },
      }
    end,
  },
  integrations = {
    cmp = true,
    gitsigns = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = { 'italic' },
        hints = { 'italic' },
        warnings = { 'italic' },
        information = { 'italic' },
      },
      underlines = {
        errors = { 'undercurl' },
        hints = { 'undercurl' },
        warnings = { 'undercurl' },
        information = { 'undercurl' },
      },
    },
    telescope = true,
    treesitter = true,
    treesitter_context = true,
  },
})
vim.cmd.colorscheme('catppuccin')
