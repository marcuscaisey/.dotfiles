local ok, lualine = pcall(require, 'lualine')
if not ok then
  return
end

local search_results = {
  function()
    local search_term = vim.fn.getreg('/') ---@cast search_term string
    local search_count = vim.fn.searchcount({
      recompute = 1,
      maxcount = -1,
    })
    return string.format('/%s [%d/%d]', search_term:gsub('%%', '%%%%'), search_count.current, search_count.total)
  end,
  cond = function()
    -- searchcount returns raises an error if there's something wrong with the search term like an unmatched \(
    local ok, search_count = pcall(vim.fn.searchcount, {
      recompute = 1,
      maxcount = -1,
    })
    return ok and search_count.total and search_count.total > 0
  end,
}

local cwd = {
  function()
    return vim.fn.getcwd():gsub('^' .. os.getenv('HOME'), '~')
  end,
  color = 'LualineCwd',
}

local lsp_progress = nil
vim.api.nvim_create_autocmd('LspProgress', {
  group = vim.api.nvim_create_augroup('lualine_lsp_progress', { clear = true }),
  callback = function(args)
    -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#workDoneProgress
    local payload = args.data.params.value
    local msg = { payload.title }
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      table.insert(msg, 1, string.format('%s: ', client.name))
    end
    if payload.message then
      table.insert(msg, string.format(': %s', payload.message))
    end
    if payload.percentage then
      table.insert(msg, string.format(' (%d%%)', payload.percentage))
    end
    lsp_progress = table.concat(msg):gsub('%%', '%%%%')
    if payload.kind == 'end' then
      vim.defer_fn(function()
        lsp_progress = nil
      end, 1000)
    end
    lualine.refresh({ place = { 'statusline' }, scope = 'window', trigger = 'autocmd' })
  end,
})

local function lsp_info()
  if lsp_progress then
    return lsp_progress
  end
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  local client_names = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
  end
  if #client_names then
    return table.concat(client_names, ', ')
  end
  return 'No Active LSP Clients'
end

lualine.setup({
  options = {
    theme = 'catppuccin',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      { 'branch', component_separators = { left = '' } },
      { 'diff', padding = { left = 0, right = 1 } },
    },
    lualine_c = {
      { 'filetype', icon_only = true, component_separators = { left = '' }, padding = { left = 1, right = 0 } },
      { 'filename', path = 1 },
      cwd,
    },
    lualine_x = { search_results },
    lualine_y = {
      { lsp_info },
      {
        'diagnostics',
        symbols = {
          error = vim.fn.sign_getdefined('DiagnosticSignError')[1].text,
          warn = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text,
          info = vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text,
          hint = vim.fn.sign_getdefined('DiagnosticSignHint')[1].text,
        },
        padding = { left = 0, right = 1 },
      },
    },
    lualine_z = {
      'location',
      { 'progress', padding = { left = 0, right = 1 } },
    },
  },
})
