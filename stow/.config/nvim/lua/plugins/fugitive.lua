vim.keymap.set('n', '<leader>gb', function()
  vim.cmd.Git('blame')
end)
