local augroup = vim.api.nvim_create_augroup('lsp', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  desc = 'Set LSP keymaps and create codelens autocmd',
  callback = function(args)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = true })
    vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, { buffer = true })
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = true })
    vim.keymap.set('n', '<leader>fm', function()
      vim.lsp.buf.format({ timeout_ms = 5000 })
    end, { buffer = true })

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.codeLensProvider then
      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost', 'CursorHold' }, {
        callback = vim.lsp.codelens.refresh,
        group = augroup,
        buffer = args.buf,
        desc = 'Refresh codelenses automatically in this buffer',
      })
    end
  end,
})

vim.lsp.set_log_level(vim.log.levels.OFF)
