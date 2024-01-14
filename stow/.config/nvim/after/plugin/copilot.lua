if vim.fn.exists(':Copilot') ~= 2 or os.getenv('NVIM_DISABLE_COPILOT') then
  return
end

local enabled = true
vim.keymap.set('n', '<leader>cc', function ()
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
