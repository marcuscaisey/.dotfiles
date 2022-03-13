local M = {}

-- A wrapper around vim.keymap.set which sets silent = true by default
M.map = function(mode, lhs, rhs, opts)
  local default_opts = { silent = true }

  opts = opts or {}
  local merged_opts = default_opts
  for k, v in pairs(opts) do
    merged_opts[k] = v
  end

  vim.keymap.set(mode, lhs, rhs, merged_opts)
end

return M
