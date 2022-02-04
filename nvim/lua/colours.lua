local lsp_utils = require 'lsp_utils'
local gruvbox = require 'gruvbox.colors'

-- lsp symbol highlights
lsp_utils.for_each_symbol_kind(function(kind)
  vim.highlight.link('LSPSymbolKind' .. kind, 'CmpItemKind' .. kind)
end)

-- gitsigns.nvim
vim.highlight.link('GitSignsAdd', 'diffAdded', true)
vim.highlight.link('GitSignsChange', 'diffChanged', true)
vim.highlight.link('GitSignsDelete', 'diffRemoved', true)

-- Diagnostics
vim.highlight.link('DiagnosticInfo', 'DiagnosticHint', true)

vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticWarn' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticHint' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticInfo' })

-- lightspeed
vim.api.nvim_set_hl(0, 'LightspeedLabel', { fg = gruvbox.bright_purple, bold = true, undercurl = true })
vim.highlight.link('LightspeedGreyWash', 'Comment', true)
vim.api.nvim_set_hl(
  0,
  'LightspeedShortcut',
  { fg = gruvbox.dark0, bg = gruvbox.bright_purple, bold = true, undercurl = true }
)
vim.api.nvim_set_hl(0, 'LightspeedMaskedChar', { fg = gruvbox.neutral_red })
vim.api.nvim_set_hl(0, 'LightspeedUnlabeledMatch', { fg = gruvbox.light1, bold = true })
vim.api.nvim_set_hl(0, 'LightspeedLabelDistant', { fg = gruvbox.bright_blue, bold = true, undercurl = true })
vim.api.nvim_set_hl(0, 'LightspeedOneCharMatch', { fg = gruvbox.dark0, bg = gruvbox.bright_purple, bold = true })
vim.api.nvim_set_hl(0, 'LightspeedPendingOpArea', { fg = gruvbox.dark0, bg = gruvbox.bright_purple })
vim.api.nvim_set_hl(0, 'LightspeedLabelOverlapped', { fg = gruvbox.faded_purple, undercurl = true })
vim.api.nvim_set_hl(
  0,
  'LightspeedShortcutOverlapped',
  { fg = gruvbox.dark0, bg = gruvbox.bright_purple, bold = true, undercurl = true }
)
vim.api.nvim_set_hl(0, 'LightspeedLabelDistantOverlapped', { fg = gruvbox.faded_blue, undercurl = true })

-- galaxyline
local mode_to_colour = {
  Normal = gruvbox.blue,
  Insert = gruvbox.bright_green,
  Command = gruvbox.light3,
  Visual = gruvbox.orange,
  VisualLine = gruvbox.orange,
  VisualBlock = gruvbox.orange,
  Replace = gruvbox.bright_purple,
}
for mode, colour in pairs(mode_to_colour) do
  vim.api.nvim_set_hl(0, 'Galaxyline' .. mode .. 'Mode', { fg = gruvbox.dark0, bg = colour })
  vim.api.nvim_set_hl(0, 'Galaxyline' .. mode .. 'ModeSeparator', { fg = colour, bg = gruvbox.dark0 })
end

vim.highlight.link('GalaxylineGitIcon', 'GruvboxOrange', true)
vim.highlight.link('GalaxylineDiffAdd', 'diffAdded', true)
vim.highlight.link('GalaxylineDiffModified', 'diffChanged', true)
vim.highlight.link('GalaxylineDiffRemove', 'diffRemoved', true)

-- nvim
vim.highlight.link('SignColumn', 'Normal', true)

-- telescope.nvim
vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { fg = gruvbox.dark1, bg = gruvbox.dark1 })
vim.api.nvim_set_hl(0, 'TelescopePromptTitle', { fg = gruvbox.light1, bg = gruvbox.dark1 })
vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { fg = gruvbox.light1, bg = gruvbox.dark1 })
vim.highlight.link('TelescopePromptCounter', 'TelescopePromptNormal', true)

vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { fg = gruvbox.dark0_hard, bg = gruvbox.dark0_hard })
vim.api.nvim_set_hl(0, 'TelescopeResultsTitle', { fg = gruvbox.dark0_hard, bg = gruvbox.dark0_hard })

vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { fg = gruvbox.dark0_hard, bg = gruvbox.dark0_hard })
vim.api.nvim_set_hl(0, 'TelescopePreviewTitle', { fg = gruvbox.light1, bg = gruvbox.dark0_hard })

vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = gruvbox.dark0_hard })

vim.highlight.link('TelescopeSelection', 'CursorLine', true)
