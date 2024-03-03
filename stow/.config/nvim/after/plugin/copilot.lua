if vim.fn.exists(':Copilot') ~= 2 then
  return
end

local enabled = true
if os.getenv('NVIM_DISABLE_COPILOT') then
  enabled = false
  vim.cmd.Copilot('disable')
end

vim.g.copilot_filetypes = {
  markdown = true,
}

vim.keymap.set('n', '<leader>cc', function()
  if enabled then
    vim.cmd.Copilot('disable')
    print('Disabled copilot')
    enabled = false
  else
    vim.cmd.Copilot('enable')
    print('Enabled copilot')
    enabled = true
  end
end)
