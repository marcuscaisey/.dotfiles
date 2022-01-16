local lsp_utils = require 'lsp_utils'

--- @class HighlightColours
--- @field guifg string|nil
--- @field guibg string|nil

--- Extracts the guifg and guibg colours from a highlight group.
--- @param name string
--- @return HighlightColours
local function extract_highlight_colours(name)
  local highlight_string = vim.api.nvim_exec('highlight ' .. name, true)
  local linked_highlight_group = highlight_string:match '.+links to (%a+)'
  if linked_highlight_group ~= nil then
    return extract_highlight_colours(linked_highlight_group)
  end
  return {
    guifg = highlight_string:match 'guifg=(#[%d%a]+)',
    guibg = highlight_string:match 'guibg=(#[%d%a]+)',
  }
end

---@class HighlightArgs
---@field guifg string|nil
---@field guibg string|nil
---@field gui string[]|nil

--- Creates a highlight group.
---@param group string
---@param args HighlightArgs
local function highlight_group(group, args)
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

-- base highlights
-- use these highlights everywhere so that they're the only ones i have to
-- switch out if i change theme
vim.highlight.link('Cyan', 'DraculaCyan', true)
vim.highlight.link('Red', 'DraculaRed', true)
vim.highlight.link('Green', 'DraculaGreen', true)
vim.highlight.link('Orange', 'DraculaOrange', true)
vim.highlight.link('Purple', 'DraculaPurple', true)
vim.highlight.link('Pink', 'DraculaPink', true)
vim.highlight.link('Fg', 'DraculaFg', true)

local palette = {
  cyan = extract_highlight_colours('Cyan').guifg,
  green = extract_highlight_colours('Green').guifg,
  orange = extract_highlight_colours('Orange').guifg,
  purple = extract_highlight_colours('Purple').guifg,
  red = extract_highlight_colours('Red').guifg,
  pink = extract_highlight_colours('Pink').guifg,

  bg = extract_highlight_colours('Normal').guibg,
  fg = extract_highlight_colours('Fg').guifg,
}

highlight_group('OrangeBoldUnderline', { guifg = palette.orange, gui = { 'bold', 'underline' } })
highlight_group('OrangeInverse', { guifg = palette.bg, guibg = palette.orange })
highlight_group(
  'OrangeInverseBoldUnderline',
  { guifg = palette.bg, guibg = palette.orange, gui = { 'bold', 'underline' } }
)
highlight_group('CyanBoldUnderline', { guifg = palette.cyan, gui = { 'bold', 'underline' } })
highlight_group('OrangeInverseBold', { guifg = palette.bg, guibg = palette.orange, gui = { 'bold' } })

-- lsp
vim.highlight.link('LSPSymbolKindFile', 'Red', true)
vim.highlight.link('LSPSymbolKindModule', 'Fg', true)
vim.highlight.link('LSPSymbolKindNamespace', 'Red', true)
vim.highlight.link('LSPSymbolKindPackage', 'Red', true)
vim.highlight.link('LSPSymbolKindClass', 'Orange', true)
vim.highlight.link('LSPSymbolKindMethod', 'Purple', true)
vim.highlight.link('LSPSymbolKindProperty', 'Cyan', true)
vim.highlight.link('LSPSymbolKindField', 'Fg', true)
vim.highlight.link('LSPSymbolKindConstructor', 'Purple', true)
vim.highlight.link('LSPSymbolKindEnum', 'Cyan', true)
vim.highlight.link('LSPSymbolKindInterface', 'Cyan', true)
vim.highlight.link('LSPSymbolKindFunction', 'Purple', true)
vim.highlight.link('LSPSymbolKindVariable', 'Cyan', true)
vim.highlight.link('LSPSymbolKindConstant', 'Fg', true)
vim.highlight.link('LSPSymbolKindString', 'Fg', true)
vim.highlight.link('LSPSymbolKindNumber', 'Red', true)
vim.highlight.link('LSPSymbolKindBoolean', 'Fg', true)
vim.highlight.link('LSPSymbolKindArray', 'Fg', true)
vim.highlight.link('LSPSymbolKindObject', 'Red', true)
vim.highlight.link('LSPSymbolKindKey', 'Fg', true)
vim.highlight.link('LSPSymbolKindNull', 'Red', true)
vim.highlight.link('LSPSymbolKindEnumMember', 'Cyan', true)
vim.highlight.link('LSPSymbolKindStruct', 'Fg', true)
vim.highlight.link('LSPSymbolKindEvent', 'Fg', true)
vim.highlight.link('LSPSymbolKindOperator', 'Red', true)
vim.highlight.link('LSPSymbolKindTypeParameter', 'Cyan', true)

-- nvim-cmp
lsp_utils.for_each_symbol_kind(function(kind)
  vim.highlight.link('CmpItemKind' .. kind, 'LSPSymbolKind' .. kind)
end)

vim.highlight.link('CmpItemKindUnit', 'Fg', true)
vim.highlight.link('CmpItemKindValue', 'Orange', true)
vim.highlight.link('CmpItemKindKeyword', 'Fg', true)
vim.highlight.link('CmpItemKindSnippet', 'Fg', true)
vim.highlight.link('CmpItemKindColor', 'Red', true)
vim.highlight.link('CmpItemKindReference', 'Fg', true)
vim.highlight.link('CmpItemKindFolder', 'Red', true)
vim.highlight.link('CmpItemKindText', 'Fg', true)
vim.highlight.link('CmpItemAbbr', 'Fg', true)
vim.highlight.link('CmpItemAbbrMatch', 'Cyan', true)
vim.highlight.link('CmpItemAbbrMatchFuzzy', 'Cyan', true)

-- diagnostics
vim.highlight.link('DiagnosticError', 'Red', true)
vim.highlight.link('DiagnosticWarn', 'Orange', true)
vim.highlight.link('DiagnosticHint', 'Cyan', true)
vim.highlight.link('DiagnosticInfo', 'Cyan', true)

vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticWarn' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticHint' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticInfo' })

-- git
vim.highlight.link('DiffDelete', 'Red', true)

-- lightspeed
vim.highlight.link('LightspeedLabel', 'OrangeBoldUnderline', true)
vim.highlight.link('LightspeedGreyWash', 'Comment', true)
vim.highlight.link('LightspeedShortcut', 'OrangeInverseBoldUnderline', true)
vim.highlight.link('LightspeedMaskedChar', 'Red', true)
vim.highlight.link('LightspeedLabelDistant', 'CyanBoldUnderline', true)
vim.highlight.link('LightspeedOneCharMatch', 'OrangeInverseBold', true)
vim.highlight.link('LightspeedPendingOpArea', 'OrangeInverse', true)
vim.highlight.link('LightspeedUnlabeledMatch', 'FgBold', true)
vim.highlight.link('LightspeedLabelOverlapped', 'Pink', true)

-- galaxyline
local mode_to_colour = {
  Normal = palette.purple,
  Insert = palette.green,
  Command = palette.cyan,
  Visual = palette.orange,
  VisualLine = palette.orange,
  VisualBlock = palette.orange,
  Replace = palette.red,
}
for mode, colour in pairs(mode_to_colour) do
  highlight_group('Galaxyline' .. mode .. 'Mode', { guifg = palette.bg, guibg = colour })
  highlight_group('Galaxyline' .. mode .. 'ModeSeparator', { guifg = colour, guibg = palette.bg })
end
