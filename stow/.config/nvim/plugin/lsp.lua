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

vim.lsp.log.set_format_func(vim.inspect)

vim.keymap.set('n', 'crl', vim.lsp.codelens.run, { desc = 'vim.lsp.codelens.run()' })
vim.keymap.set('n', 'crf', vim.lsp.buf.format, { desc = 'vim.lsp.buf.format()' })
vim.keymap.set('n', 'crn', vim.lsp.buf.rename, { desc = 'vim.lsp.buf.rename()' })

local function map_codeaction(mode, lhs)
  vim.keymap.set(mode, lhs, vim.lsp.buf.code_action, { desc = 'vim.lsp.buf.code_action()' })
end
map_codeaction('n', 'crr')
map_codeaction('x', '<C-R>r')
map_codeaction('x', '<C-R><C-R>')
