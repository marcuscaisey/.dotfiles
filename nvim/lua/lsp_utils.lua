local codicons = require 'codicons'

local M = {}

local symbol_kinds = {
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

--- Returns a codicon for a given LSP symbol kind.
--- @param kind string LSP SymbolKind as defined in the protocol (https://microsoft.github.io/language-server-protocol/specifications/specification-3-17/#symbolKind)
--- @return string
M.symbol_codicon = function(kind)
  return codicons.get('symbol-' .. pascal_to_snake_case(kind))
end

--- Calls the given callback on each LSP symbol kind, returning a table mapping
--- each kind to its corresponding result.
--- @param callback function Callback which accepts LSP SymbolKinds, as strings, as defined in the protocol (https://microsoft.github.io/language-server-protocol/specifications/specification-3-17/#symbolKind) and optionally returns something which should be used as each symbol kind's value in the returned table.
--- @return table
M.for_each_symbol_kind = function(callback)
  local callback_results = {}
  for _, kind in ipairs(symbol_kinds) do
    callback_results[kind] = callback(kind)
  end
  return callback_results
end

return M
