local ok, devicons = pcall(require, 'nvim-web-devicons')
if not ok then
  return
end

vim.g.statusline_git = ''
vim.g.statusline_file = ''
vim.g.statusline_lsp = ''
vim.g.statusline_diagnostics = ''
vim.g.statusline_location = ''

vim.o.statusline = table.concat({
  ' ',
  '%(%{%g:statusline_git%}  %)',
  '%{%g:statusline_file%}',
  '%=',
  '%(%{%g:statusline_lsp%}  %)',
  '%(%{%g:statusline_diagnostics%}  %)',
  '%{%g:statusline_location%}',
  ' ',
})

---@param group string
local function hl(group)
  return '%#' .. group .. '#'
end

---@type {name:string, hl_group:string, symbol:string}[]
local git_status_sections = {
  { name = 'added', hl_group = 'diffAdded', symbol = '+' },
  { name = 'changed', hl_group = 'diffChanged', symbol = '~' },
  { name = 'removed', hl_group = 'diffRemoved', symbol = '-' },
}

local function update_statusline_git()
  local result = {}
  local gitsigns_head = vim.b.gitsigns_head ---@type string?
  if gitsigns_head then
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
    table.insert(result, hl(icon_gl_group) .. icon .. ' ' .. hl('StatusLine') .. vim.b.git_head)
    local status_counts = vim.b.gitsigns_status_dict ---@type {added:integer?, changed:integer?, removed:integer?}?
    if status_counts then
      local status = {}
      for _, section in ipairs(git_status_sections) do
        local count = status_counts[section.name]
        if count and count > 0 then
          table.insert(status, hl(section.hl_group) .. section.symbol .. count)
        end
      end
      if #status > 0 then
        table.insert(result, table.concat(status, ' '))
      end
    end
  end
  vim.g.statusline_git = table.concat(result, ' ')
end

---@param bufnr integer
local function update_statusline_file(bufnr)
  local icon, hl_group = devicons.get_icon(vim.api.nvim_buf_get_name(bufnr), nil, { default = true })
  local cwd = vim.fn.getcwd()
  local filename = '%f'
  -- %f is "Path to the file in the buffer, as typed or relative to current directory.". For normal buffers, construct
  -- the filename to ensure that it's always relative to the cwd.
  if vim.bo.buftype == '' then
    filename = vim.api.nvim_buf_get_name(bufnr)
    filename = vim.fs.relpath(cwd, filename) or filename
    if filename == '.' then
      filename = '[No Name]'
    end
  end
  if vim.env.HOME then
    cwd = cwd:gsub('^' .. vim.pesc(vim.env.HOME), '~')
  end
  vim.g.statusline_file = hl(hl_group) .. icon .. ' ' .. hl('StatusLine') .. filename .. ' %(%h%w%m%r %)' .. hl('StatusLineNC') .. cwd
end

local lsp_progress = nil ---@type string?

---@param opts {bufnr:integer, exclude_client_id:integer?, progress:LSPWorkDoneProgress?}
local function update_statusline_lsp(opts)
  local result
  if opts.progress then
    if opts.progress.kind == 'end' then
      lsp_progress = nil
    else
      lsp_progress = vim.lsp.status():gsub('%%', '%%%%')
    end
  end
  if lsp_progress then
    result = lsp_progress
  else
    local clients = vim.lsp.get_clients({ bufnr = opts.bufnr })
    local client_names = {}
    for _, client in ipairs(clients) do
      if client.id ~= opts.exclude_client_id then
        table.insert(client_names, client.name)
      end
    end
    result = table.concat(client_names, ', ')
  end
  vim.g.statusline_lsp = hl('StatusLine') .. result
end

local diagnostic_severity_hl_groups = {
  [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
  [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
  [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
  [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
}

local diagnostic_severity_signs = vim.diagnostic.config().signs.text
assert(diagnostic_severity_signs, 'Expected signs.text to be populated in vim.diagnostic.config()')

---@param bufnr integer
local function update_statusline_diagnostics(bufnr)
  local counts = vim.diagnostic.count(bufnr)
  local result = {} ---@type string[]
  for level, count in pairs(counts) do
    table.insert(result, hl(diagnostic_severity_hl_groups[level]) .. diagnostic_severity_signs[level] .. ' ' .. count)
  end
  vim.g.statusline_diagnostics = table.concat(result, ' ')
end

vim.g.statusline_location = hl('StatusLine') .. '%11(%l:%v %p%%%)'

local augroup = vim.api.nvim_create_augroup('statusline', {})

vim.api.nvim_create_autocmd('BufEnter', {
  group = augroup,
  desc = 'Update g:statusline_git, g:statusline_file, g:statusline_lsp, g:statusline_diagnostics',
  callback = function(args)
    update_statusline_git()
    update_statusline_file(args.buf)
    update_statusline_lsp({ bufnr = args.buf })
    update_statusline_diagnostics(args.buf)
  end,
})

vim.api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'GitSignsUpdate',
  desc = 'Update g:statusline_git and redraw status line',
  callback = function()
    update_statusline_git()
    vim.cmd.redrawstatus()
  end,
})

vim.api.nvim_create_autocmd('DirChanged', {
  group = augroup,
  desc = 'Update g:statusline_file',
  callback = function(args)
    update_statusline_file(args.buf)
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  desc = 'Update g:statusline_lsp and redraw status line',
  callback = function(args)
    update_statusline_lsp({ bufnr = args.buf })
    vim.cmd.redrawstatus()
  end,
})
vim.api.nvim_create_autocmd('LspDetach', {
  group = augroup,
  desc = 'Update g:statusline_lsp and redraw status line',
  callback = function(args)
    update_statusline_lsp({ bufnr = args.buf, exclude_client_id = args.data.client_id })
    vim.cmd.redrawstatus()
  end,
})
---@alias LSPWorkDoneProgress lsp.WorkDoneProgressBegin|lsp.WorkDoneProgressReport|lsp.WorkDoneProgressEnd
---@class LspProgressCallbackArgs : vim.api.keyset.create_autocmd.callback_args
---@field data {params:{value:LSPWorkDoneProgress}}
vim.api.nvim_create_autocmd('LspProgress', {
  group = augroup,
  desc = 'Update g:statusline_lsp and redraw status line',
  ---@param args LspProgressCallbackArgs
  callback = function(args)
    update_statusline_lsp({ bufnr = args.buf, progress = args.data.params.value })
    vim.cmd.redrawstatus()
  end,
})

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  group = augroup,
  desc = 'Update g:statusline_diagnostics if diagnostics changed in current buffer',
  callback = function(args)
    if args.buf == vim.api.nvim_get_current_buf() then
      update_statusline_diagnostics(args.buf)
    end
  end,
})
