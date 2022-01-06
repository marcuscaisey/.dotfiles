local highlight = vim.highlight
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
local lsp_utils = require 'lsp_utils'

--- @class HighlightColours
--- @field guifg string|nil
--- @field guibg string|nil

--- Extracts the guifg and guibg colours from a highlight group.
--- @param name string
--- @return HighlightColours
local function extract_highlight_colours(name)
  local highlight_string = api.nvim_exec('highlight ' .. name, true)
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
  cmd(highlight_cmd)
end

-- base highlights
-- use these highlights everywhere so that they're the only ones i have to
-- switch out if i change theme
highlight.link('Cyan', 'DraculaCyan', true)
highlight.link('Red', 'DraculaRed', true)
highlight.link('Green', 'DraculaGreen', true)
highlight.link('Orange', 'DraculaOrange', true)
highlight.link('Purple', 'DraculaPurple', true)
highlight.link('Pink', 'DraculaPink', true)
highlight.link('Fg', 'DraculaFg', true)
highlight.link('BgLighter', 'DraculaBgLighter', true)
highlight.link('Comment', 'DraculaComment', true)

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
highlight.link('LSPSymbolKindFile', 'Red', true)
highlight.link('LSPSymbolKindModule', 'Fg', true)
highlight.link('LSPSymbolKindNamespace', 'Red', true)
highlight.link('LSPSymbolKindPackage', 'Red', true)
highlight.link('LSPSymbolKindClass', 'Orange', true)
highlight.link('LSPSymbolKindMethod', 'Purple', true)
highlight.link('LSPSymbolKindProperty', 'Cyan', true)
highlight.link('LSPSymbolKindField', 'Fg', true)
highlight.link('LSPSymbolKindConstructor', 'Purple', true)
highlight.link('LSPSymbolKindEnum', 'Cyan', true)
highlight.link('LSPSymbolKindInterface', 'Cyan', true)
highlight.link('LSPSymbolKindFunction', 'Purple', true)
highlight.link('LSPSymbolKindVariable', 'Cyan', true)
highlight.link('LSPSymbolKindConstant', 'Fg', true)
highlight.link('LSPSymbolKindString', 'Fg', true)
highlight.link('LSPSymbolKindNumber', 'Red', true)
highlight.link('LSPSymbolKindBoolean', 'Fg', true)
highlight.link('LSPSymbolKindArray', 'Fg', true)
highlight.link('LSPSymbolKindObject', 'Red', true)
highlight.link('LSPSymbolKindKey', 'Fg', true)
highlight.link('LSPSymbolKindNull', 'Red', true)
highlight.link('LSPSymbolKindEnumMember', 'Cyan', true)
highlight.link('LSPSymbolKindStruct', 'Fg', true)
highlight.link('LSPSymbolKindEvent', 'Fg', true)
highlight.link('LSPSymbolKindOperator', 'Red', true)
highlight.link('LSPSymbolKindTypeParameter', 'Cyan', true)

-- nvim-cmp
lsp_utils.for_each_symbol_kind(function(kind)
  highlight.link('CmpItemKind' .. kind, 'LSPSymbolKind' .. kind)
end)

highlight.link('CmpItemKindUnit', 'Fg', true)
highlight.link('CmpItemKindValue', 'Orange', true)
highlight.link('CmpItemKindKeyword', 'Fg', true)
highlight.link('CmpItemKindSnippet', 'Fg', true)
highlight.link('CmpItemKindColor', 'Red', true)
highlight.link('CmpItemKindReference', 'Fg', true)
highlight.link('CmpItemKindFolder', 'Red', true)
highlight.link('CmpItemKindText', 'Fg', true)
highlight.link('CmpItemAbbr', 'Fg', true)
highlight.link('CmpItemAbbrMatch', 'Cyan', true)
highlight.link('CmpItemAbbrMatchFuzzy', 'Cyan', true)

-- diagnostics
highlight.link('DiagnosticError', 'Red', true)
highlight.link('DiagnosticWarn', 'Orange', true)
highlight.link('DiagnosticHint', 'Cyan', true)
highlight.link('DiagnosticInfo', 'Cyan', true)

fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticError' })
fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticWarn' })
fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticHint' })
fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticInfo' })

-- git
highlight.link('DiffDelete', 'Red', true)

-- lightspeed
highlight.link('LightspeedLabel', 'OrangeBoldUnderline', true)
highlight.link('LightspeedGreyWash', 'Comment', true)
highlight.link('LightspeedShortcut', 'OrangeInverseBoldUnderline', true)
highlight.link('LightspeedMaskedChar', 'Red', true)
highlight.link('LightspeedLabelDistant', 'CyanBoldUnderline', true)
highlight.link('LightspeedOneCharMatch', 'OrangeInverseBold', true)
highlight.link('LightspeedPendingOpArea', 'OrangeInverse', true)
highlight.link('LightspeedUnlabeledMatch', 'FgBold', true)
highlight.link('LightspeedLabelOverlapped', 'Pink', true)

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

-- treesitter-context
highlight.link('TreesitterContext', 'BgLighter', true)

--- nvim
highlight.link('Pmenu', 'BgLighter', true)
