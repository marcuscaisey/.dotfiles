local augroup = vim.api.nvim_create_augroup('lsp', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  desc = 'Configure LSP client',
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens) then
      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost', 'CursorHold' }, {
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = args.buf })
        end,
        group = augroup,
        buffer = args.buf,
        desc = 'Refresh codelenses',
      })
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) and vim.bo.formatprg == '' then
      vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format, { desc = 'vim.lsp.buf.format()', buffer = args.buf })
    end

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

vim.lsp.log.set_format_func(vim.inspect)
if vim.env.NVIM_DISABLE_LSP_LOGGING == 'true' then
  vim.lsp.set_log_level(vim.log.levels.OFF)
end
if vim.env.NVIM_LSP_LOG_LEVEL then
  vim.lsp.set_log_level(vim.env.NVIM_LSP_LOG_LEVEL)
end

vim.keymap.set('n', 'grl', vim.lsp.codelens.run, { desc = 'vim.lsp.codelens.run()' })
