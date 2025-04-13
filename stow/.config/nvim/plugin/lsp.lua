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

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_formatting) and vim.bo.formatprg == '' then
      vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format, { desc = 'vim.lsp.buf.format()', buffer = args.buf })
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

local enabled_lsps = {
  'bashls',
  'clangd',
  'jsonls',
  'loxls',
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
    vim.print(vim.lsp.config[name].cmd)
  end
end

vim.lsp.config('clangd', {
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' }, -- Default excluding proto
})

vim.lsp.config('pyright', {
  ---@param params lsp.InitializeParams
  ---@param config vim.lsp.ClientConfig
  ---@diagnostic disable-next-line: unused-local
  before_init = function(params, config)
    if not config.root_dir then
      return
    end
    if vim.uv.fs_stat(vim.fs.joinpath(config.root_dir, '.plzconfig')) then
      ---@diagnostic disable-next-line: param-type-mismatch
      config.settings.python = vim.tbl_deep_extend('force', config.settings.python, {
        analysis = {
          extraPaths = {
            vim.fs.joinpath(config.root_dir, 'plz-out/python/venv'),
          },
          exclude = { 'plz-out' },
        },
      })
    end
  end,
})

vim.lsp.config('ts_ls', {
  ---@param client vim.lsp.Client
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
})

vim.keymap.set('n', 'grl', vim.lsp.codelens.run, { desc = 'vim.lsp.codelens.run()' })
