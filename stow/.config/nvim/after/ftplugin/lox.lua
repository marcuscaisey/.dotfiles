vim.opt_local.commentstring = '// %s'
vim.opt_local.textwidth = 120

vim.lsp.start({
  name = 'loxls',
  cmd = { 'loxls' },
  root_dir = vim.fs.root(0, '.git'),
})
