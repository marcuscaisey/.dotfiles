local g = vim.g
local cmd = vim.cmd

g.neoformat_only_msg_on_error = true

g.neoformat_enabled_python = {'black'}

g.neoformat_enabled_lua = {'luaformat'}

g.neoformat_lua_luaformat = {
  exe = 'lua-format',
  args = {'--indent-width', '2', '--double-quote-to-single-quote'}
}

-- Autoformat go files on save
cmd('autocmd BufWritePre *.go silent Neoformat gofmt')

-- Organise go imports on save
cmd('autocmd BufWritePre *.go silent Neoformat goimports')

-- Autoformat lua files on save
cmd('autocmd BufWritePre *.lua silent Neoformat')
