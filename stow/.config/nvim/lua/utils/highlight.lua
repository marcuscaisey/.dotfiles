local M = {}

-- A wrapper around vim.highlight.link which always replaces existing links
M.link = function(from, to)
  vim.api.nvim_set_hl(0, from, { link = to })
end

-- A wrapper around vim.api.nvim_set_hl which always creates in the global namespace
M.create = function(name, opts)
  local namespace_id = 0 -- global namespace
  vim.api.nvim_set_hl(namespace_id, name, opts)
end

return M
