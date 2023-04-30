local catppuccin = require('catppuccin')
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
        GitConflictCurrent = { bg = colors.darken(palette.green, 0.2, palette.base) },
        GitConflictIncoming = { bg = colors.darken(palette.blue, 0.2, palette.base) },
        GitConflictAncestor = { bg = palette.surface1 },
        LualineCwd = { fg = palette.surface2, bg = palette.mantle },
        IncSearch = { bg = palette.peach },
        NormalFloat = { fg = palette.overlay2, bg = palette.surface0 },
        DiffChange = { bg = colors.darken(palette.blue, 0.15, palette.base) },
        DiffText = { bg = colors.darken(palette.blue, 0.3, palette.base) },
      }
    end,
  },
  integrations = {
    cmp = true,
    dap = {
      enabled = true,
      enable_ui = true,
    },
    gitsigns = true,
    leap = true,
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
