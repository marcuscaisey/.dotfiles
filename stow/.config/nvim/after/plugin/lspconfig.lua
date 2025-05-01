vim.keymap.set('n', '<Leader>rl', function()
  local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
  for _, client in ipairs(clients) do
    vim.cmd.LspRestart(client.name)
  end
end)
