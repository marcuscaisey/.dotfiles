vim.keymap.set({ 'o', 'v' }, 'ae', ':<C-U>execute "normal! gg" | keepjumps normal! VG<CR>', {
  desc = '"around everything" text object, selects everything in the buffer',
  silent = true,
})

---@param row integer
---@return string
local function get_line(row)
  return vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
end

---@param line string
---@return integer
local function get_indent(line)
  local _, indent = vim.text.indent(0, line, { expandtab = vim.bo.tabstop })
  return indent
end

---@param s string
---@return boolean
local function is_blank(s)
  return s:match('^%s*$') ~= nil
end

vim.keymap.set({ 'o', 'v' }, 'ii', function()
  local cur_row = unpack(vim.api.nvim_win_get_cursor(0))
  local select_start = cur_row
  local select_end = cur_row
  local cur_indent = 0

  -- Increase the selection upwards until we find a non-blank line.
  while select_start > 1 do
    local line = get_line(select_start)
    if not is_blank(line) then
      cur_indent = get_indent(line)
      break
    end
    select_start = select_start - 1
  end

  -- If the start of the selection is now above the current row, then the current line is blank and the first non-blank
  -- line below current one might be indented more. There may also be no indented lines above the current one at all.
  if select_start < cur_row then
    select_end = cur_row + 1
    while select_end <= vim.api.nvim_buf_line_count(0) do
      local line = get_line(select_end)
      if not is_blank(line) then
        local indent = get_indent(line)
        if cur_indent == 0 then
          cur_indent = indent
        elseif indent < cur_indent then
          select_end = select_end - 1
        elseif indent > cur_indent then
          cur_indent = indent
          select_start = select_start + 1
        end
        break
      end
      select_end = select_end + 1
    end
  end

  -- Increase the selection upwards until we find a non-blank line which is indented less than the current level.
  while select_start > 1 do
    local line = get_line(select_start - 1)
    if not is_blank(line) and get_indent(line) < cur_indent then
      break
    end
    select_start = select_start - 1
  end

  -- Increase the selection downwards until we find a non-blank line which is indented less than the current level.
  while select_end < vim.api.nvim_buf_line_count(0) do
    local next_line = get_line(select_end + 1)
    if not is_blank(next_line) and get_indent(next_line) < cur_indent then
      break
    end
    select_end = select_end + 1
  end

  return string.format(':<C-U>normal! %dGV%dG<CR>', select_start, select_end)
end, { expr = true, silent = true, desc = '"inner indent" text object, selects the current indentation level' })
