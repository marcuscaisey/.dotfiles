local highlight = vim.highlight
local fn = vim.fn

-- nvim-cmp
highlight.link('CmpItemKindText', 'DraculaFg', true)
highlight.link('CmpItemKindMethod', 'DraculaPurple', true)
highlight.link('CmpItemKindFunction', 'DraculaPurple', true)
highlight.link('CmpItemKindConstructor', 'DraculaPurple', true)
highlight.link('CmpItemKindField', 'DraculaCyan', true)
highlight.link('CmpItemKindVariable', 'DraculaCyan', true)
highlight.link('CmpItemKindClass', 'DraculaOrange', true)
highlight.link('CmpItemKindInterface', 'DraculaCyan', true)
highlight.link('CmpItemKindModule', 'DraculaFg', true)
highlight.link('CmpItemKindProperty', 'DraculaCyan', true)
-- highlight.link('CmpItemKindUnit', 'DraculaPurple', true)
-- highlight.link('CmpItemKindValue', 'DraculaPurple', true)
highlight.link('CmpItemKindEnum', 'DraculaCyan', true)
-- highlight.link('CmpItemKindKeyword', 'DraculaPurple', true)
-- highlight.link('CmpItemKindSnippet', 'DraculaPurple', true)
-- highlight.link('CmpItemKindColor', 'DraculaPurple', true)
-- highlight.link('CmpItemKindFile', 'DraculaPurple', true)
-- highlight.link('CmpItemKindReference', 'DraculaPurple', true)
-- highlight.link('CmpItemKindFolder', 'DraculaPurple', true)
-- highlight.link('CmpItemKindEnumMember', 'DraculaPurple', true)
highlight.link('CmpItemKindConstant', 'DraculaFg', true)
highlight.link('CmpItemKindStruct', 'DraculaFg', true)
-- highlight.link('CmpItemKindEvent', 'DraculaPurple', true)
-- highlight.link('CmpItemKindOperator', 'DraculaPurple', true)
-- highlight.link('CmpItemKindTypeParameter', 'DraculaPurple', true)

highlight.link('CmpItemAbbr', 'DraculaFg', true)
highlight.link('CmpItemAbbrMatch', 'DraculaCyan', true)
highlight.link('CmpItemAbbrMatchFuzzy', 'DraculaCyan', true)
highlight.link('CmpItemKind', 'DraculaPurple', true)

-- lsp
fn.sign_define('DiagnosticSignError',
               {text = '', texthl = 'LspDiagnosticsError'})
fn.sign_define('DiagnosticSignWarn',
               {text = '', texthl = 'LspDiagnosticsWarning'})
fn.sign_define('DiagnosticSignHint',
               {text = '', texthl = 'LspDiagnosticsHint'})

highlight.link('DiagnosticError', 'LspDiagnosticsError', true)
highlight.link('DiagnosticWarn', 'LspDiagnosticsWarning', true)
highlight.link('DiagnosticHint', 'LspDiagnosticsHint', true)

