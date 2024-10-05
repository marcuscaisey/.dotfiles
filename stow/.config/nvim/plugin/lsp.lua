local protocol = require('vim.lsp.protocol')

local augroup = vim.api.nvim_create_augroup('lsp', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  desc = 'Create codelens autocmd',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.supports_method(protocol.Methods.textDocument_codeLens) then
      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost', 'CursorHold' }, {
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = args.buf })
        end,
        group = augroup,
        buffer = args.buf,
        desc = 'Refresh codelenses automatically in this buffer',
      })
    end
  end,
})

-- Format JSON-RPC messages as JSON
vim.lsp.log.set_format_func(function(...)
  return vim.inspect(..., {
    newline = '',
    process = function(item, _)
      if type(item) == 'table' and item.jsonrpc then
        return vim.json.encode(item)
      else
        return item
      end
    end,
  })
end)
if vim.env.NVIM_DISABLE_LSP_LOGGING == 'true' then
  vim.lsp.set_log_level(vim.log.levels.OFF)
end
if vim.env.NVIM_LSP_LOG_LEVEL then
  vim.lsp.set_log_level(vim.env.NVIM_LSP_LOG_LEVEL)
end

vim.keymap.set('n', 'grl', vim.lsp.codelens.run, { desc = 'vim.lsp.codelens.run()' })
vim.keymap.set('n', 'grf', function()
  vim.lsp.buf.format({ timeout_ms = 5000 })
end, { desc = 'vim.lsp.buf.format()' })
