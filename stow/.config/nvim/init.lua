vim.loader.enable()

vim.g.mapleader = ' '

vim.g.loaded_matchit = 1

vim.g.copilot_no_tab_map = true

---@diagnostic disable-next-line: duplicate-set-field
vim.deprecate = function() end

local original_notify = vim.notify

---@param msg string
---@param level integer?
---@param opts table?
---@diagnostic disable-next-line: duplicate-set-field
function vim.notify(msg, level, opts)
  if vim.startswith(msg, 'position_encoding param is required in vim.lsp.util.make_range_params.') then
    return
  end
  return original_notify(msg, level, opts)
end
