local lsp_utils = require 'utils.lsp'
local highlight = require 'utils.highlight'
local gruvbox = require 'gruvbox.colors'

-- lsp symbol highlights
lsp_utils.for_each_symbol_kind(function(kind)
  highlight.link('LSPSymbol' .. kind, 'CmpItemKind' .. kind)
end)

-- gitsigns.nvim
highlight.link('GitSignsAdd', 'diffAdded')
highlight.link('GitSignsChange', 'diffChanged')
highlight.link('GitSignsDelete', 'diffRemoved')

-- Diagnostics
highlight.link('DiagnosticInfo', 'DiagnosticHint')

vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticWarn' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticHint' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticInfo' })

-- leap
highlight.create('LeapMatch', { fg = gruvbox.bright_aqua, underline = true })
highlight.create('LeapLabelPrimary', { fg = gruvbox.dark0, bg = gruvbox.bright_aqua })
highlight.create('LeapLabelSecondary', { fg = gruvbox.dark0, bg = gruvbox.bright_blue })

-- galaxyline
local mode_to_colour = {
  Normal = gruvbox.blue,
  Insert = gruvbox.bright_green,
  Command = gruvbox.light3,
  Visual = gruvbox.orange,
  VisualLine = gruvbox.orange,
  VisualBlock = gruvbox.orange,
  Replace = gruvbox.bright_purple,
  Terminal = gruvbox.bright_aqua,
}
for mode, colour in pairs(mode_to_colour) do
  highlight.create('Galaxyline' .. mode .. 'Mode', { fg = gruvbox.dark0, bg = colour })
  highlight.create('Galaxyline' .. mode .. 'ModeSeparator', { fg = colour, bg = gruvbox.dark0 })
end
highlight.link('GalaxylineGitIcon', 'GruvboxOrange')
highlight.link('GalaxylineDiffAdd', 'diffAdded')
highlight.link('GalaxylineDiffModified', 'diffChanged')
highlight.link('GalaxylineDiffRemove', 'diffRemoved')

-- nvim
highlight.link('SignColumn', 'Normal')

-- telescope.nvim
highlight.create('TelescopePromptBorder', { fg = gruvbox.dark1, bg = gruvbox.dark1 })
highlight.create('TelescopePromptTitle', { fg = gruvbox.light1, bg = gruvbox.dark1 })
highlight.create('TelescopePromptNormal', { fg = gruvbox.light1, bg = gruvbox.dark1 })
highlight.link('TelescopePromptCounter', 'TelescopePromptNormal')
highlight.create('TelescopeResultsBorder', { fg = gruvbox.dark0_hard, bg = gruvbox.dark0_hard })
highlight.create('TelescopeResultsTitle', { fg = gruvbox.dark0_hard, bg = gruvbox.dark0_hard })
highlight.create('TelescopePreviewBorder', { fg = gruvbox.dark0_hard, bg = gruvbox.dark0_hard })
highlight.create('TelescopePreviewTitle', { fg = gruvbox.light1, bg = gruvbox.dark0_hard })
highlight.create('TelescopeNormal', { bg = gruvbox.dark0_hard })
highlight.link('TelescopeSelection', 'CursorLine')

-- neo-tree.nvim
highlight.link('NeoTreeSymbolicLinkTarget', 'Comment')
