local enabled_lsps = {
  'bashls',
  'clangd',
  'efm',
  'gopls',
  'intelephense',
  'jsonls',
  'loxls',
  'lua_ls',
  'marksman',
  'please',
  'pyright',
  'ts_ls',
  'vimls',
}
if vim.env.NVIM_DISABLE_GOLANGCI_LINT ~= 'true' then
  table.insert(enabled_lsps, 'golangci_lint_ls')
end
vim.lsp.enable(enabled_lsps)

if vim.env.NVIM_ENABLE_LSP_DEVTOOLS == 'true' then
  for _, name in ipairs(enabled_lsps) do
    vim.lsp.config(name, {
      cmd = { 'lsp-devtools', 'agent', '--', unpack(vim.lsp.config[name].cmd) },
    })
  end
end

local augroup = vim.api.nvim_create_augroup('lsp', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  desc = 'Create codelens autocmd and format mapping',
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
  end,
})

if vim.env.NVIM_DISABLE_LSP_LOGGING == 'true' then
  vim.lsp.set_log_level(vim.log.levels.OFF)
end
if vim.env.NVIM_LSP_LOG_LEVEL then
  vim.lsp.set_log_level(vim.env.NVIM_LSP_LOG_LEVEL)
end

vim.keymap.set('n', 'grl', vim.lsp.codelens.run, { desc = 'vim.lsp.codelens.run()' })
vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format, { desc = 'vim.lsp.buf.format()' })
