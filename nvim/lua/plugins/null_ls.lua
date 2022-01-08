local null_ls = require 'null-ls'

null_ls.setup {
  sources = {
    null_ls.builtins.diagnostics.golangci_lint.with {
      extra_args = {
        '--exclude-use-default=false',
        '-E',
        'revive',
      },
    },
    null_ls.builtins.diagnostics.flake8,
  },
  on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
      vim.cmd 'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'
    end
  end,
}
