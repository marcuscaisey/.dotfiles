if vim.fn.exists(':Copilot') ~= 2 then
  return
end

vim.g.copilot_filetypes = {
  markdown = true,
}

vim.g.copilot_enabled = false

vim.keymap.set('n', '<leader>cc', function()
  if vim.g.copilot_enabled then
    print('Disabled copilot')
    vim.g.copilot_enabled = false
  else
    print('Enabled copilot')
    vim.g.copilot_enabled = true
  end
end, { desc = 'Toggle copilot' })

vim.keymap.set('i', '<C-Y>', 'copilot#Accept("\\<C-Y>")', { expr = true, replace_keycodes = false })
vim.keymap.set('i', '<C-E>', 'pumvisible() ? "<C-E>" : "<Plug>(copilot-dismiss)"', {
  expr = true,
  replace_keycodes = false,
})
