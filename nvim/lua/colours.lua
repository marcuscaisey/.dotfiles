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

-- lsp
highlight.link('LSPSymbolKindFile', 'DraculaRed', true)
highlight.link('LSPSymbolKindModule', 'DraculaFg', true)
highlight.link('LSPSymbolKindNamespace', 'DraculaRed', true)
highlight.link('LSPSymbolKindPackage', 'DraculaRed', true)
highlight.link('LSPSymbolKindClass', 'DraculaOrange', true)
highlight.link('LSPSymbolKindMethod', 'DraculaPurple', true)
highlight.link('LSPSymbolKindProperty', 'DraculaCyan', true)
highlight.link('LSPSymbolKindField', 'DraculaFg', true)
highlight.link('LSPSymbolKindConstructor', 'DraculaPurple', true)
highlight.link('LSPSymbolKindEnum', 'DraculaCyan', true)
highlight.link('LSPSymbolKindInterface', 'DraculaCyan', true)
highlight.link('LSPSymbolKindFunction', 'DraculaPurple', true)
highlight.link('LSPSymbolKindVariable', 'DraculaCyan', true)
highlight.link('LSPSymbolKindConstant', 'DraculaFg', true)
highlight.link('LSPSymbolKindString', 'DraculaRed', true)
highlight.link('LSPSymbolKindNumber', 'DraculaRed', true)
highlight.link('LSPSymbolKindBoolean', 'DraculaRed', true)
highlight.link('LSPSymbolKindArray', 'DraculaRed', true)
highlight.link('LSPSymbolKindObject', 'DraculaRed', true)
highlight.link('LSPSymbolKindKey', 'DraculaRed', true)
highlight.link('LSPSymbolKindNull', 'DraculaRed', true)
highlight.link('LSPSymbolKindEnumMember', 'DraculaCyan', true)
highlight.link('LSPSymbolKindStruct', 'DraculaFg', true)
highlight.link('LSPSymbolKindEvent', 'DraculaFg', true)
highlight.link('LSPSymbolKindOperator', 'DraculaRed', true)
highlight.link('LSPSymbolKindTypeParameter', 'DraculaCyan', true)

-- nvim-cmp
lsp_utils.for_each_symbol_kind(function(kind)
  highlight.link('CmpItemKind' .. kind, 'LSPSymbolKind' .. kind)
end)

highlight.link('CmpItemKindUnit', 'DraculaRed', true)
highlight.link('CmpItemKindValue', 'DraculaRed', true)
highlight.link('CmpItemKindKeyword', 'DraculaFg', true)
highlight.link('CmpItemKindSnippet', 'DraculaFg', true)
highlight.link('CmpItemKindColor', 'DraculaRed', true)
highlight.link('CmpItemKindReference', 'DraculaFg', true)
highlight.link('CmpItemKindFolder', 'DraculaRed', true)
highlight.link('CmpItemKindText', 'DraculaFg', true)
highlight.link('CmpItemAbbr', 'DraculaFg', true)
highlight.link('CmpItemAbbrMatch', 'DraculaCyan', true)
highlight.link('CmpItemAbbrMatchFuzzy', 'DraculaCyan', true)

-- diagnostics
fn.sign_define('DiagnosticSignError', { text = '', texthl = 'LspDiagnosticsError' })
fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'LspDiagnosticsWarning' })
fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'LspDiagnosticsHint' })

highlight.link('DiagnosticError', 'LspDiagnosticsError', true)
highlight.link('DiagnosticWarn', 'LspDiagnosticsWarning', true)
highlight.link('DiagnosticHint', 'LspDiagnosticsHint', true)

-- git
highlight.link('DiffDelete', 'DraculaRed', true)

local palette = {
  cyan = extract_highlight_colours('DraculaCyan').guifg,
  green = extract_highlight_colours('DraculaCyan').guifg,
  orange = extract_highlight_colours('DraculaOrange').guifg,
  purple = extract_highlight_colours('DraculaPurple').guifg,
  red = extract_highlight_colours('DraculaRed').guifg,
  pink = extract_highlight_colours('DraculaPink').guifg,

  bg = extract_highlight_colours('Normal').guibg,
  fg = extract_highlight_colours('Normal').guifg,
}

-- lightspeed
highlight_group('DraculaOrangeBoldUnderline', { guifg = palette.orange, gui = { 'bold', 'underline' } })
highlight.link('LightspeedLabel', 'DraculaOrangeBoldUnderline', true)
highlight.link('LightspeedGreyWash', 'DraculaComment', true)
highlight_group(
  'DraculaOrangeInverseBoldUnderline',
  { guifg = palette.bg, guibg = palette.orange, gui = { 'bold', 'underline' } }
)
highlight.link('LightspeedShortcut', 'DraculaOrangeInverseBoldUnderline', true)
highlight.link('LightspeedMaskedChar', 'DraculaRed', true)
highlight_group('DraculaCyanBoldUnderline', { guifg = palette.cyan, gui = { 'bold', 'underline' } })
highlight.link('LightspeedLabelDistant', 'DraculaCyanBoldUnderline', true)
highlight_group('DraculaOrangeInverseBold', { guifg = palette.bg, guibg = palette.orange, gui = { 'bold' } })
highlight.link('LightspeedOneCharMatch', 'DraculaOrangeInverseBold', true)
highlight.link('LightspeedPendingOpArea', 'DraculaOrangeInverse', true)
highlight.link('LightspeedUnlabeledMatch', 'DraculaFgBold', true)

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
