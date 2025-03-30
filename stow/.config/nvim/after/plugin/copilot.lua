vim.g.copilot_filetypes = {
  markdown = true,
}

vim.g.copilot_enabled = vim.env.NVIM_DISABLE_COPILOT ~= 'true'
if vim.g.copilot_enabled then
  vim.cmd.packadd('copilot.vim')
  vim.keymap.set('i', '<C-E>', 'pumvisible() ? "<C-E>" : "<Plug>(copilot-dismiss)"', {
    expr = true,
    replace_keycodes = false,
  })
end

vim.keymap.set('n', '<Leader>cc', function()
  if vim.g.copilot_enabled then
    print('Disabled copilot')
    vim.g.copilot_enabled = false
  else
    print('Enabled copilot')
    vim.g.copilot_enabled = true
  end
end, { desc = 'Toggle copilot' })
