local M = {}

local olddirs_file = vim.fn.stdpath('data') .. '/olddirs'
local limit = 100

local cd_and_save_path = function(cd_func, path)
  path = vim.fs.normalize(path)
  cd_func(vim.fn.fnameescape(path))

  local olddirs = { path }
  local f = io.open(olddirs_file, 'r')
  if f then
    for line in f:lines() do
      if line ~= path then
        table.insert(olddirs, line)
      end
    end
    f:close()
  end

  f = assert(io.open(olddirs_file, 'w+'))
  local file_content = table.concat(olddirs, '\n', 1, math.min(limit, #olddirs))
  assert(f:write(file_content))
  f:close()
end

---Wrapper around |:cd| which saves {path} to the olddirs file.
---@param path string The target directory.
M.cd = function(path)
  cd_and_save_path(vim.cmd.cd, path)
end

---Wrapper around |:lcd| which saves {path} to the olddirs file.
---@param path string The target directory.
M.lcd = function(path)
  cd_and_save_path(vim.cmd.lcd, path)
end

---Wrapper around |:tcd| which saves {path} to the olddirs file.
---@param path string The target directory.
M.tcd = function(path)
  cd_and_save_path(vim.cmd.tcd, path)
end

---Returns the paths from the olddirs file if it exists, otherwise an empty table.
---@return table
M.get = function()
  local f = io.open(olddirs_file, 'r')
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
