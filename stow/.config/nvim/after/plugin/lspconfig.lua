vim.keymap.set('n', '<Leader>rl', function()
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  for _, client in ipairs(clients) do
    if vim.lsp.config[client.name] then
      vim.cmd.LspRestart(client.name)
    end
  end
end)

vim.api.nvim_create_user_command('LspLog', function()
  vim.cmd(string.format('tabnew %s', vim.lsp.get_log_path()))
end, { desc = 'Opens the Nvim LSP client log.' })
