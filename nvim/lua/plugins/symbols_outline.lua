local g = vim.g
local lsp_utils = require 'lsp_utils'

local symbols = {}
for _, symbol_type in ipairs(lsp_utils.symbol_types) do
  symbols[symbol_type] = { icon = lsp_utils.symbol_icon(symbol_type) }
end

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
  symbols = symbols,
}
