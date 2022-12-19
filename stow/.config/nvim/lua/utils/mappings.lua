local M = {}

local default_opts = { silent = true }

-- A wrapper around vim.keymap.set which sets some default options
M.map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  for k, v in pairs(default_opts) do
    if not opts[k] then
      opts[k] = v
    end
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

-- A wrapper around vim.api.nvim_buf_set_keymap which sets some default options
M.buf_map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  for k, v in pairs(default_opts) do
    if not opts[k] then
      opts[k] = v
    end
  end

  vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
end

return M
