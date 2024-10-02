local ok, null_ls = pcall(require, 'null-ls')
if not ok then
  return
end
local helpers = require('null-ls.helpers')

local loxfmt = {
  method = null_ls.methods.FORMATTING,
  filetypes = { 'lox' },
  generator = helpers.formatter_factory({
    command = 'loxfmt',
    to_stdin = true,
  }),
}

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.prettierd,
    loxfmt,
  },
})
