local augroup = vim.api.nvim_create_augroup('yank', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank({ timeout = 500 })
  end,
  group = augroup,
  desc = 'Highlight yanked text',
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

---@param root string
---@return string?
---@return string? errmsg
local function git_ref(root)
  local upstream_branch_res = vim.system({ 'git', '-C', root, 'rev-parse', '--abbrev-ref', '@{upstream}' }):wait()
  if upstream_branch_res.code == 0 then
    local upstream_branch = vim.trim(upstream_branch_res.stdout)
    local remote_branch = upstream_branch:match('^origin/(.+)')
    if remote_branch then
      return remote_branch
    end
  elseif not upstream_branch_res.stderr:match('HEAD does not point to a branch') then
    return nil, string.format('determining upstream branch: %s', upstream_branch_res.stderr)
  end

  local tag_res = vim.system({ 'git', '-C', root, 'tag', '--points-at', 'HEAD' }):wait()
  if tag_res.code ~= 0 then
    return nil, string.format('determining tag: %s', tag_res.stderr)
  end
  local tag = vim.trim(tag_res.stdout)
  if tag ~= '' then
    return tag
  end

  return nil, 'determining git ref: no upstream branch or tag found'
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

vim.keymap.set('n', '<Leader>ys', function()
  local base_url = vim.env.SOURCEGRAPH_BASE_URL
  if not base_url then
    vim.notify('Yanking sourcegraph URL: SOURCEGRAPH_BASE_URL env var not set', vim.log.levels.ERROR)
    return
  end

  local git_root = vim.trim(vim.system({ 'git', 'rev-parse', '--show-toplevel' }):wait().stdout)
  local filepath = vim.api.nvim_buf_get_name(0)
  local relative_filepath = vim.fs.relpath(git_root, filepath)

  local git_ref, errmsg = git_ref(git_root)
  if not git_ref then
    vim.notify(string.format('Yanking sourcegraph URL: %s', errmsg), vim.log.levels.WARN)
  end

  local git_ref_segment = git_ref and '@' .. git_ref or ''
  local line = unpack(vim.api.nvim_win_get_cursor(0))
  local url = string.format('%s%s/-/blob/%s?L%d', base_url, git_ref_segment, relative_filepath, line)

  yank(url)
end, { desc = 'Yank the sourcegraph URL to the current position in the buffer' })

vim.keymap.set('n', '<Leader>yg', function()
  local path = vim.api.nvim_buf_get_name(0)
  local git_root, errmsg = git_root(vim.api.nvim_buf_get_name(0))
  if not git_root then
    vim.notify(string.format('Yanking github URL: %s', errmsg), vim.log.levels.ERROR)
    return
  end

  local git_remote_result = vim.system({ 'git', '-C', git_root, 'remote', 'get-url', 'origin' }):wait()
  local base_url = vim.trim(git_remote_result.stdout)
  if base_url == '' then
    vim.notify(string.format('Yanking github URL: getting url of origin remote: %s', git_remote_result.stderr), vim.log.levels.ERROR)
    return
  end

  local git_ref, errmsg = git_ref(git_root)
  if not git_ref then
    vim.notify(string.format('Yanking github URL: %s', errmsg), vim.log.levels.ERROR)
    return
  end

  local line = unpack(vim.api.nvim_win_get_cursor(0))
  local rel_path = vim.fs.relpath(git_root, path)
  local url = string.format('%s/blob/%s/%s#L%d', base_url, git_ref, rel_path, line)

  yank(url)
end, { desc = 'Yank the github URL to the current position in the buffer' })
