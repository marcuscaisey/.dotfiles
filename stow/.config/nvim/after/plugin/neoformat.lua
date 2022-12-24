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
