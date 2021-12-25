local null_ls = require 'null-ls'
local cmd = vim.cmd

null_ls.setup {
  sources = {
    null_ls.builtins.diagnostics.golangci_lint.with {
      extra_args = {
        '--exclude-use-default=false',
        '-E',
        'revive',
      },
    },
  },
  on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
      cmd 'autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()'
    end
  end,
}
