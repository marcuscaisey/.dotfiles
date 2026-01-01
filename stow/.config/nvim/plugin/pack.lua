vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, { desc = 'vim.pack.update()' })

vim.api.nvim_create_user_command('PackRevert', function()
  vim.pack.update(nil, { target = 'lockfile' })
end, { desc = "vim.pack.update(nil, { target = 'lockfile' })" })
