vim.g.neoformat_enabled_python = { 'black' }
vim.g.neoformat_enabled_lua = { 'stylua' }
vim.g.neoformat_enabled_go = { 'goimports' }
vim.g.neoformat_enabled_sql = { 'sqlformat' }

vim.g.neoformat_sql_sqlformat = {
  exe = 'sqlformat',
  args = { '--reindent', '--keywords', 'upper', '--identifiers', 'lower', '-' },
  stdin = 1,
}

vim.g.neoformat_javascript_prettier = {
  exe = 'prettier',
  args = { '--stdin-filepath', '"%:p"', '--print-width', '100' },
  stdin = 1,
  try_node_exe = 1,
}

local M = {}

local auto_neoformatting_enabled = true

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    if require('file_types').auto_format_file_types[vim.o.filetype] and auto_neoformatting_enabled then
      vim.cmd 'Neoformat'
    end
  end,
  group = vim.api.nvim_create_augroup('neoformat', { clear = true }),
})

--- Toggles Neoformat auto-formatting on save
M.toggle_auto_neoformatting = function()
  if auto_neoformatting_enabled then
    auto_neoformatting_enabled = false
    print 'Neoformat: disabled autoformatting'
  else
    auto_neoformatting_enabled = true
    print 'Neoformat: enabled autoformatting'
  end
end

M.auto_neoformatting_enabled = function()
  return auto_neoformatting_enabled
end

return M
