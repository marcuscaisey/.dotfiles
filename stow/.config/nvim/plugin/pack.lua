vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, { desc = 'vim.pack.update()' })
