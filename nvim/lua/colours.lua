local lsp_utils = require 'utils.lsp'
local highlight = require 'utils.highlight'
local gruvbox = require 'gruvbox.colors'

local M = {}

-- lsp symbol highlights
lsp_utils.for_each_symbol_kind(function(kind)
  highlight.link('LSPSymbol' .. kind, 'CmpItemKind' .. kind)
end)

-- gruvbox.nvim
highlight.link('diffChanged', 'GruvboxOrange')
highlight.create('DiffChanged', { fg = gruvbox.orange, bg = gruvbox.bg0 })
highlight.create('GitGutterChange', { fg = gruvbox.orange, bg = gruvbox.bg1 })

-- gitsigns.nvim
highlight.link('GitSignsAdd', 'diffAdded')
highlight.link('GitSignsChange', 'diffChanged')
highlight.link('GitSignsDelete', 'diffRemoved')

vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticHint' })

-- leap
highlight.create('LeapMatch', { fg = gruvbox.bright_aqua, underline = true })
highlight.create('LeapLabelPrimary', { fg = gruvbox.dark0, bg = gruvbox.bright_aqua })
highlight.create('LeapLabelSecondary', { fg = gruvbox.dark0, bg = gruvbox.bright_blue })

-- lualine
local mode_to_colour = {
  normal = gruvbox.blue,
  insert = gruvbox.bright_green,
  visual = gruvbox.orange,
  replace = gruvbox.bright_purple,
  command = gruvbox.light3,
}

M.lualine = {}
for mode, colour in pairs(mode_to_colour) do
  M.lualine[mode] = {
    a = { bg = colour, fg = gruvbox.dark0 },
    b = { bg = gruvbox.dark2, fg = gruvbox.white },
    c = { bg = gruvbox.dark1, fg = gruvbox.white },
  }
end

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

-- luasnip
highlight.create('LuasnipChoiceVirtualText', { fg = gruvbox.bright_aqua, bg = gruvbox.dark1 })

-- git-conflict.nvim
highlight.create('GitConflictCurrent', { fg = gruvbox.dark0, bg = gruvbox.faded_blue })
highlight.create('GitConflictIncoming', { fg = gruvbox.dark0, bg = gruvbox.faded_aqua })

-- nvim-dap
highlight.link('DapBreakpoint', 'GruvboxPurple')
highlight.link('DapBreakpointRejected', 'GruvboxRed')

return M
