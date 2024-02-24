local protocol = require('vim.lsp.protocol')

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

    -- Disable LSP formatting with gq, see :help lsp-defaults
    vim.bo[args.buf].formatexpr = nil
  end,
})

vim.lsp.set_log_level(vim.log.levels.OFF)
