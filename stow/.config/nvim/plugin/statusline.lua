local api = vim.api
local diagnostic = vim.diagnostic
local fn = vim.fn
local lsp = vim.lsp
local ok, devicons = pcall(require, 'nvim-web-devicons')
if not ok then
  return
end

local augroup = api.nvim_create_augroup('statusline', { clear = true })

---@param group string
local function hl(group)
  return '%#' .. group .. '#'
end

api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'GitSignsUpdate',
  desc = 'Redraw statusline',
  command = 'redrawstatus',
})
---@type {name:string, hl_group:string, symbol:string}[]
local git_status_sections = {
  { name = 'added', hl_group = 'diffAdded', symbol = '+' },
  { name = 'changed', hl_group = 'diffChanged', symbol = '~' },
  { name = 'removed', hl_group = 'diffRemoved', symbol = '-' },
}

---@return string
function StatusLineGitSection()
  local result = {}
  local head = vim.b.gitsigns_head ---@type string?
  if head then
    local icon, icon_gl_group = devicons.get_icon(nil, 'git')
    table.insert(result, hl(icon_gl_group) .. icon .. ' ' .. hl('StatusLine') .. head)
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
  return table.concat(result, ' ')
end

---@return string
function StatusLineFileSection()
  local icon, hl_group = devicons.get_icon(api.nvim_buf_get_name(0), nil, { default = true })
  local cwd = fn.getcwd():gsub('^' .. vim.env.HOME, '~')
  return hl(hl_group) .. icon .. ' ' .. hl('StatusLine') .. '%f %(%h%w%m%r %)' .. hl('StatusLineNC') .. cwd
end

local lsp_progress = nil
api.nvim_create_autocmd('LspProgress', {
  group = augroup,
  desc = 'Update statusline with LSP progress or clear it if the work is done',
  ---@param args {data:{params:{value:lsp.WorkDoneProgressBegin|lsp.WorkDoneProgressReport|lsp.WorkDoneProgressEnd}}}
  callback = function(args)
    if args.data.params.value.kind == 'end' then
      lsp_progress = nil
    else
      lsp_progress = lsp.status():gsub('%%', '%%%%')
    end
    vim.cmd.redrawstatus()
  end,
})
api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
  group = augroup,
  desc = 'Redraw statusline',
  command = 'redrawstatus',
})

---@return string
function StatusLineLSPSection()
  local result
  if lsp_progress then
    result = lsp_progress
  else
    local clients = lsp.get_clients({ bufnr = 0 })
    local client_names = {}
    for _, client in ipairs(clients) do
      table.insert(client_names, client.name)
    end
    result = table.concat(client_names, ', ')
  end
  return hl('StatusLine') .. result
end

local diagnostic_severity_hl_groups = {
  [diagnostic.severity.ERROR] = 'DiagnosticSignError',
  [diagnostic.severity.WARN] = 'DiagnosticSignWarn',
  [diagnostic.severity.INFO] = 'DiagnosticSignInfo',
  [diagnostic.severity.HINT] = 'DiagnosticSignHint',
}

local diagnostic_severity_signs = diagnostic.config().signs.text
assert(diagnostic_severity_signs, 'Expected signs.text to be populated in vim.diagnostic.config()')

---@return string
function StatusLineDiagnosticsSection()
  local counts = diagnostic.count(0)
  local result = {} ---@type string[]
  for level, count in pairs(counts) do
    table.insert(result, hl(diagnostic_severity_hl_groups[level]) .. diagnostic_severity_signs[level] .. ' ' .. count)
  end
  return table.concat(result, ' ')
end

local padding = '  '

---@return string
function StatusLine()
  return table.concat({
    ' ',
    '%(%{%v:lua.StatusLineGitSection()%}' .. padding .. '%)',
    '%{%v:lua.StatusLineFileSection()%}',
    '%=',
    '%(%{%v:lua.StatusLineLSPSection()%}' .. padding .. '%)',
    '%(%{%v:lua.StatusLineDiagnosticsSection()%}' .. padding .. '%)',
    hl('StatusLine') .. '%11(%l:%v %p%%%)',
    ' ',
  })
end

vim.opt.statusline = '%!v:lua.StatusLine()'
