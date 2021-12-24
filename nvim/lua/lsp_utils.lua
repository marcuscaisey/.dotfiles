local codicons = require 'codicons'

local M = {}

M.symbol_types = {
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

--- Returns the icon for a given LSP symbol type.
--- @param symbol_type string Symbol type in PascalCase
--- @return string
M.symbol_icon = function(symbol_type)
  return codicons.get('symbol-' .. pascal_to_snake_case(symbol_type))
end

return M
