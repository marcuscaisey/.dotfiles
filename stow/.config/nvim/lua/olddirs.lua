local M = {}

local history_file = vim.fn.stdpath('data') .. '/cwd-history'
local history_limit = 100

M.setcwd = function(path)
  path = vim.fs.normalize(path)
  vim.cmd.lcd(vim.fn.fnameescape(path))

  local history = { path }
  local f = io.open(history_file, 'r')
  if f then
    for line in f:lines() do
      if line ~= path then
        table.insert(history, line)
      end
    end
    f:close()
  end

  f = assert(io.open(history_file, 'w+'))
  local content = table.concat(history, '\n', 1, math.min(history_limit, #history))
  assert(f:write(content))
  f:close()
end

M.get = function()
  local f = io.open(history_file, 'r')
  if not f then
    return {}
  end
  local dirs = {}
  for line in f:lines() do
    table.insert(dirs, line)
  end
  f:close()
  return dirs
end

return M
