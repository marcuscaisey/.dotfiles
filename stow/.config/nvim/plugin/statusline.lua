local ok, devicons = pcall(require, 'nvim-web-devicons')
if not ok then
  return
end

---@param group string
local function hl(group)
  return '%#' .. group .. '#'
end

vim.o.statusline = table.concat({
  ' ',
  '%(%{% v:lua.StatuslineGit() %}  %)',
  '%{% v:lua.StatuslineFile() %}',
  '%=',
  '%(%{% v:lua.StatuslineLSPClients() %}  %)',
  '%(%{% v:lua.StatuslineDiagnostics() %}  %)',
  hl('StatusLine') .. '%(%l:%v %p%%%)',
  ' ',
})

---@return string
function StatuslineGit()
  local gitsigns_head = vim.b.gitsigns_head ---@type string?
  if not gitsigns_head then
    return ''
  end
  if gitsigns_head ~= vim.b.prev_gitsigns_head then
    vim.b.prev_gitsigns_head = gitsigns_head
    vim.b.git_head = gitsigns_head
    local current_branch = vim.trim(vim.system({ 'git', 'branch', '--show-current' }):wait().stdout)
    if current_branch == '' then
      -- If the current branch is empty, it means we are in a detached HEAD state.
      local tag = vim.trim(vim.system({ 'git', 'describe', '--tags', '--exact-match', gitsigns_head }):wait().stdout)
      if tag ~= '' then
        vim.b.git_head = tag
      end
    end
  end
  local icon, icon_gl_group = devicons.get_icon(nil, 'git')
  local result = hl(icon_gl_group) .. icon .. ' ' .. hl('StatusLine') .. vim.b.git_head
  if vim.b.gitsigns_status ~= '' then
    result = result .. ' ' .. vim.b.gitsigns_status
  end
  return result
end

---@return string
function StatuslineFile()
  local icon, hl_group = devicons.get_icon(vim.api.nvim_buf_get_name(0), nil, { default = true })
  local cwd = vim.fn.getcwd()
  local filename = '%f'
  -- %f is "Path to the file in the buffer, as typed or relative to current directory.". For normal buffers, construct
  -- the filename to ensure that it's always relative to the cwd.
  if vim.bo.buftype == '' then
    filename = vim.api.nvim_buf_get_name(0)
    filename = vim.fs.relpath(cwd, filename) or filename
    if filename == '.' then
      filename = '[No Name]'
    end
  end
  if vim.env.HOME then
    cwd = cwd:gsub('^' .. vim.pesc(vim.env.HOME), '~')
  end
  return hl(hl_group) .. icon .. ' ' .. hl('StatusLine') .. filename .. ' %(%h%w%m%r %)' .. hl('StatusLineNC') .. cwd
end

---@return string
function StatuslineLSPClients()
  local client_names = {}
  for _, client in ipairs(vim.lsp.get_clients()) do
    if not client:is_stopped() then
      table.insert(client_names, client.name)
    end
  end
  return hl('StatusLine') .. table.concat(client_names, ', ')
end

---@return string
function StatuslineDiagnostics()
  return vim.diagnostic.status()
end

vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
  group = vim.api.nvim_create_augroup('statusline', {}),
  desc = 'Redraw the statusline',
  callback = function()
    vim.api.nvim__redraw({ statusline = true })
  end,
})
