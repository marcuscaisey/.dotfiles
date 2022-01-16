local lsp_utils = require 'lsp_utils'
local gruvbox = require 'gruvbox.colors'

---@class HighlightArgs
---@field guifg string|nil
---@field guibg string|nil
---@field gui string[]|nil

--- Creates a highlight group.
---@param group string
---@param args HighlightArgs
local function highlight(group, args)
  local highlight_cmd = 'highlight ' .. group
  if args.guifg then
    highlight_cmd = highlight_cmd .. ' guifg=' .. args.guifg
  end
  if args.guibg then
    highlight_cmd = highlight_cmd .. ' guibg=' .. args.guibg
  end
  if args.gui then
    highlight_cmd = highlight_cmd .. ' gui=' .. table.concat(args.gui, ',')
  end
  vim.cmd(highlight_cmd)
end

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
highlight('LightspeedLabel', { guifg = gruvbox.bright_purple, gui = { 'bold', 'underline' } })
vim.highlight.link('LightspeedGreyWash', 'Comment', true)
highlight('LightspeedShortcut', {
  guifg = gruvbox.dark0,
  guibg = gruvbox.bright_purple,
  gui = { 'bold', 'underline' },
})
highlight('LightspeedMaskedChar', { guifg = gruvbox.neutral_red })
highlight('LightspeedUnlabeledMatch', { guifg = gruvbox.light1, gui = { 'bold' } })
highlight('LightspeedLabelDistant', { guifg = gruvbox.bright_blue, gui = { 'bold', 'underline' } })
highlight('LightspeedOneCharMatch', { guifg = gruvbox.dark0, guibg = gruvbox.bright_purple, gui = { 'bold' } })
highlight('LightspeedPendingOpArea', { guifg = gruvbox.dark0, guibg = gruvbox.bright_purple })
highlight('LightspeedLabelOverlapped', { guifg = gruvbox.faded_purple, gui = { 'underline' } })
highlight(
  'LightspeedShortcutOverlapped',
  { guifg = gruvbox.dark0, guibg = gruvbox.bright_purple, gui = { 'bold', 'underline' } }
)
highlight('LightspeedLabelDistantOverlapped', { guifg = gruvbox.faded_blue, gui = { 'underline' } })

-- galaxyline
local mode_to_colour = {
  Normal = gruvbox.purple,
  Insert = gruvbox.green,
  Command = gruvbox.cyan,
  Visual = gruvbox.orange,
  VisualLine = gruvbox.orange,
  VisualBlock = gruvbox.orange,
  Replace = gruvbox.red,
}
for mode, colour in pairs(mode_to_colour) do
  highlight('Galaxyline' .. mode .. 'Mode', { guifg = gruvbox.dark0, guibg = colour })
  highlight('Galaxyline' .. mode .. 'ModeSeparator', { guifg = colour, guibg = gruvbox.dark0 })
end

vim.highlight.link('GalaxylineGitIcon', 'GruvboxOrange', true)
vim.highlight.link('GalaxylineDiffAdd', 'diffAdded', true)
vim.highlight.link('GalaxylineDiffModified', 'diffChanged', true)
vim.highlight.link('GalaxylineDiffRemove', 'diffRemoved', true)

-- nvim
vim.highlight.link('SignColumn', 'Normal', true)

-- telescope.nvim
vim.highlight.link('TelescopeSelection', 'CursorLine', true)
