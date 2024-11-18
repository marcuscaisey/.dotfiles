vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2

vim.lsp.start({
  name = 'ts_ls',
  cmd = { 'typescript-language-server', '--stdio' },
  init_options = { hostInfo = 'neovim' },
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
  root_dir = vim.fs.root(0, { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' }),
})
