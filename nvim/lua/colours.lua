local highlight = vim.highlight
local api = vim.api
local fn = vim.fn
local lsp_utils = require 'lsp_utils'

local M = {}

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

-- symbols-outline.nvim
highlight.link('FocusedSymbol', 'DraculaOrangeInverse', true)

-- sneak
highlight.link('Sneak', 'IncSearch', true)

--- Parses a given highlight group into a table of guifg and guibg colours.
--- @param name string
--- @return table
local function parse_highlight(name)
  local highlight_string = api.nvim_exec('highlight ' .. name, true)
  return {
    guifg = highlight_string:match 'guifg=(#[%d%a]+)',
    guibg = highlight_string:match 'guibg=(#[%d%a]+)',
  }
end

M.palette = {
  cyan = parse_highlight('DraculaCyan').guifg,
  green = parse_highlight('DraculaCyan').guifg,
  orange = parse_highlight('DraculaOrange').guifg,
  purple = parse_highlight('DraculaPurple').guifg,
  red = parse_highlight('DraculaRed').guifg,

  bg = parse_highlight('Normal').guibg,
  fg = parse_highlight('Normal').guifg,
}

return M
