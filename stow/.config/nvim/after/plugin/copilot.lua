if vim.fn.exists(':Copilot') ~= 2 then
  return
end

vim.g.copilot_filetypes = {
  markdown = true,
}

if os.getenv('NVIM_DISABLE_COPILOT') then
  vim.g.copilot_enabled = false
end

vim.keymap.set('n', '<leader>cc', function()
  if vim.g.copilot_enabled then
    print('Disabled copilot')
    vim.g.copilot_enabled = false
  else
    print('Enabled copilot')
    vim.g.copilot_enabled = true
  end
end)

vim.keymap.set('i', '<c-e>', '<Plug>(copilot-dismiss)')
