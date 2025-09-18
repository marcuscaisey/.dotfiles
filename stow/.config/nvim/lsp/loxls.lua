---@type vim.lsp.Config
return {
  cmd = { 'go', 'run', 'github.com/marcuscaisey/lox/loxls' },
  cmd_cwd = vim.fs.joinpath(vim.env.HOME, 'scratch', 'lox'),
  filetypes = { 'lox' },
}
