require('catppuccin').setup({
  flavour = 'mocha',
  color_overrides = {
    mocha = {
      base = '#000000',
    },
  },
  highlight_overrides = {
    mocha = function(palette)
      return {
        GitConflictCurrentLabel = { bg = '#158472' },
        GitConflictCurrent = { bg = '#27403B' },
        GitConflictIncomingLabel = { bg = '#395F8F' },
        GitConflictIncoming = { bg = '#243A5E' },
        GitConflictAncestorLabel = { bg = '#45475a' },
        GitConflictAncestor = { bg = '#585b70' },
        IncSearch = { bg = palette.peach },
        NormalFloat = { fg = palette.overlay2, bg = palette.surface0 },
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
        errors = { 'underline' },
        hints = { 'underline' },
        warnings = { 'underline' },
        information = { 'underline' },
      },
    },
    telescope = true,
    treesitter = true,
    treesitter_context = true,
  },
})
vim.cmd.colorscheme({ args = { 'catppuccin' } })