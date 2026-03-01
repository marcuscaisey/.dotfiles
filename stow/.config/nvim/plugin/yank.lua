vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('yank_highlight', {}),
  desc = 'Highlight yanked text',
  callback = function()
    vim.hl.on_yank({ timeout = 500 })
  end,
})

---@param s string
local function yank(s)
  vim.fn.setreg('"', s)
  vim.fn.setreg('*', s)
  print(string.format('Yanked %s', s))
end

---@param path string
---@return string?
---@return string? errmsg
local function git_root(path)
  local root = vim.fs.root(path, '.git')
  if not root then
    return nil, 'locating git root: not in a git repo'
  end
  return root
end

vim.keymap.set('n', '<Leader>yy', function()
  local path = vim.api.nvim_buf_get_name(0)
  local git_root, errmsg = git_root(vim.api.nvim_buf_get_name(0))
  if not git_root then
    vim.notify(string.format('Yanking path: %s', errmsg), vim.log.levels.ERROR)
    return
  end
  local rel_path = vim.fs.relpath(git_root, path)
  ---@cast rel_path -nil
  yank(rel_path)
end, { desc = 'Yank the path of the current buffer relative to the git root' })

vim.keymap.set('n', '<Leader>YY', function()
  yank(vim.api.nvim_buf_get_name(0))
end, { desc = 'Yank the absolute path of the current buffer' })
