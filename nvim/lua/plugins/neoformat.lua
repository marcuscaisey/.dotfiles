-- Format all files with extensions defined here on save
local autoformatted_extensions = {
  'go',
  'lua',
  'py',
}

for k, v in pairs(autoformatted_extensions) do
  autoformatted_extensions[k] = '*.' .. v
end
vim.cmd(string.format(
  [[
  augroup auto_neoformat
    autocmd!
    autocmd BufWritePre %s silent lua AutoNeoformat()
  augroup END
]],
  table.concat(autoformatted_extensions, ',')
))

vim.g.neoformat_enabled_python = { 'black' }
vim.g.neoformat_enabled_lua = { 'stylua' }
vim.g.neoformat_enabled_go = { 'goimports' }

vim.g.neoformat_lua_luaformat = {
  exe = 'lua-format',
  args = {
    '--column-limit',
    '120',
    '--indent-width',
    '2',
    '--double-quote-to-single-quote',
  },
}

local auto_formatting_enabled = true

--- Toggles Neoformat auto-formatting for filetypes which configured to be
-- formatted on save.
local function toggle_auto_neoformatting()
  if auto_formatting_enabled then
    auto_formatting_enabled = false
    print 'Neoformat: disabled autoformatting'
  else
    auto_formatting_enabled = true
    print 'Neoformat: enabled autoformatting'
  end
end

--- Wrapper around the vimscript Neoformat command which only runs Neoformat if
-- auto-formatting is currently enabled. Auto-formatting can be toggled by
-- calling ToggleAutoNeoformatting().
function AutoNeoformat()
  if auto_formatting_enabled then
    vim.cmd 'Neoformat'
  end
end

return {
  toggle_auto_neoformatting = toggle_auto_neoformatting,
}
