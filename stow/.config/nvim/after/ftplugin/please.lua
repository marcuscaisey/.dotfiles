vim.opt_local.textwidth = 120
vim.opt_local.formatoptions:remove('t')

vim.lsp.start({
  name = 'please',
  cmd = { 'plz', 'tool', 'lps' },
  root_dir = vim.fs.root(0, '.plzconfig'),
})
