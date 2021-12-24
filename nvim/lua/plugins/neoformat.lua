local g = vim.g
local cmd = vim.cmd

-- Format all files with extensions defined here on save
local autoformatted_extensions = {'go', 'lua'}

for k, v in pairs(autoformatted_extensions) do autoformatted_extensions[k] = '*.' .. v end
cmd(string.format([[
  augroup auto_neoformat
    autocmd!
    autocmd BufWritePre %s undojoin | silent Neoformat
  augroup END
]], table.concat(autoformatted_extensions, ',')))

g.neoformat_enabled_python = {'black'}
g.neoformat_enabled_lua = {'luaformat'}
g.neoformat_enabled_go = {'gofmt', 'goimports'}

g.neoformat_lua_luaformat = {
  exe = 'lua-format',
  args = {'--column-limit', '120', '--indent-width', '2', '--double-quote-to-single-quote'}
}

g.neoformat_run_all_formatters = true



