local g = vim.g
local lsp_utils = require 'lsp_utils'

g.symbols_outline = {
  auto_preview = false,
  position = 'left',
  auto_close = true,
  show_symbol_details = false,
  keymaps = {
    goto_location = { '<cr>', 'l' },
    hover_symbol = 'K',
    toggle_preview = '<c-space>',
  },
  symbols = lsp_utils.for_each_symbol_kind(function(kind)
    return { icon = lsp_utils.symbol_icon(kind), hl = 'LSPSymbolKind' .. kind }
  end
  ),
}
