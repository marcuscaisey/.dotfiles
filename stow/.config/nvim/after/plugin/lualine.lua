local search_results = {
  function()
    local search_term = vim.fn.getreg('/')
    local search_count = vim.fn.searchcount({
      recompute = 1,
      maxcount = -1,
    })
    return string.format('/%s [%d/%d]', search_term, search_count.current, search_count.total)
  end,
  cond = function()
    local search_count = vim.fn.searchcount({
      recompute = 1,
      maxcount = -1,
    })
    return search_count.total > 0
  end,
}

local cwd = {
  function()
    return vim.fn.getcwd():gsub('^' .. os.getenv('HOME'), '~')
  end,
  color = 'LualineCwd',
}

local lsp_clients = function()
  local client_names = vim.tbl_map(function(client)
    return client.name
  end, vim.lsp.get_active_clients({ bufnr = 0 }))
  return #client_names > 0 and table.concat(client_names, ', ') or 'No Active LSP Clients'
end

require('lualine').setup({
  options = {
    theme = 'catppuccin',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
      quickfix = {},
    },
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {
      { 'branch', component_separators = { left = '' } },
      { 'diff', padding = { left = 0, right = 1 } },
    },
    lualine_c = {
      {
        'filetype',
        icon_only = true,
        component_separators = { left = '' },
        padding = { left = 1, right = 0 },
      },
      'filename',
      cwd,
    },
    lualine_x = { search_results },
    lualine_y = {
      { lsp_clients, component_separators = { right = '' } },
      {
        'diagnostics',
        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
        padding = { left = 0, right = 1 },
      },
    },
    lualine_z = {
      'location',
      { 'progress', padding = { left = 0, right = 1 } },
    },
  },
})
