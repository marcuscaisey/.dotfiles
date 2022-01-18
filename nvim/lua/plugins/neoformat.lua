vim.g.neoformat_enabled_python = { 'black' }
vim.g.neoformat_enabled_lua = { 'stylua' }
vim.g.neoformat_enabled_go = { 'goimports' }

-- Format these filetypes on save
local autoformatted_filetypes = {
  go = true,
  lua = true,
  python = true,
  proto = true,
}

vim.cmd 'augroup auto_neoformat'
vim.cmd '  autocmd!'
vim.cmd '  autocmd BufWritePre * silent lua AutoNeoformat()'
vim.cmd 'augroup END'

local auto_formatting_enabled = true

--- Toggles Neoformat auto-formatting for filetypes which configured to be formatted on save.
local function toggle_auto_neoformatting()
  if auto_formatting_enabled then
    auto_formatting_enabled = false
    print 'Neoformat: disabled autoformatting'
  else
    auto_formatting_enabled = true
    print 'Neoformat: enabled autoformatting'
  end
end

--- Wrapper around the vimscript Neoformat command which only runs Neoformat if the filetype is in -
--- autoformatted_filetypes and auto-formatting is currently enabled. Auto-formatting can be toggled by - calling
--- ToggleAutoNeoformatting().
function AutoNeoformat()
  print(autoformatted_filetypes[vim.o.filetype], auto_formatting_enabled)
  if autoformatted_filetypes[vim.o.filetype] and auto_formatting_enabled then
    vim.cmd 'Neoformat'
  end
end

return {
  toggle_auto_neoformatting = toggle_auto_neoformatting,
}
