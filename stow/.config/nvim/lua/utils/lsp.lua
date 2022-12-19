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
