require('catppuccin').setup({
  flavour = 'mocha',
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
