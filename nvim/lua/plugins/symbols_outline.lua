local g = vim.g
local codicons = require 'codicons'

local symbol_types = {
  'File',
  'Module',
  'Namespace',
  'Package',
  'Class',
  'Method',
  'Property',
  'Field',
  'Constructor',
  'Enum',
  'Interface',
  'Function',
  'Variable',
  'Constant',
  'String',
  'Number',
  'Boolean',
  'Array',
  'Object',
  'Key',
  'Null',
  'EnumMember',
  'Struct',
  'Event',
  'Operator',
  'TypeParameter',
}

local function pascal_to_snake_case(s)
  return s:gsub('(%l)(%u)', '%1-%2'):lower()
end

local function codicons_icon(symbol_type)
  return codicons.get('symbol-' .. pascal_to_snake_case(symbol_type))
end

local symbols = {}
for _, symbol_type in ipairs(symbol_types) do
  symbols[symbol_type] = { icon = codicons_icon(symbol_type) }
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
