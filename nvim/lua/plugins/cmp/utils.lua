local M = {}

local replace_termcodes = function(s)
  return vim.api.nvim_replace_termcodes(s, false, false, true)
end

M.feedkeys = function(keys, mode)
  vim.api.nvim_feedkeys(replace_termcodes(keys), mode, true)
end

--- Check if we should tab out of a pair of brackets / quotes. Returns true if
--- the next character is a:
--- - closing bracket
--- - quote and we're inside a pair of them
--- @return boolean
M.should_tab_out = function()
  local brackets = {
    [')'] = true,
    [']'] = true,
    ['}'] = true,
  }
  local quotes = {
    ["'"] = true,
    ['"'] = true,
    ['`'] = true,
  }

  local line = vim.fn.getline '.'
  local col = vim.fn.col '.'
  local next_char = line:sub(col, col)

  if quotes[next_char] then
    local preceding_chars = line:sub(1, col - 1)
    local num_preceding_quotes = select(2, preceding_chars:gsub(next_char, ''))
    -- if odd number of preceding quotes, then we're currently inside a pair
    return num_preceding_quotes % 2 == 1
  end
  return brackets[next_char] == true
end

return M
