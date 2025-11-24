local enabled_lsps = {
  'basedpyright',
  'bashls',
  'clangd',
  'dartls',
  'efm',
  'eslint',
  'golangci_lint_ls',
  'gopls',
  'intelephense',
  'jdtls',
  'jsonls',
  'loxls',
  'lua_ls',
  'marksman',
  'please',
  'ts_ls',
  'vimls',
  'yamlls',
}

if vim.env.NVIM_ENABLE_LSP_DEVTOOLS == 'true' then
  vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('lsp_devtools_setup', {}),
    desc = 'Wrap each language server command with the LSP devtools agent and before enabling',
    callback = function()
      for _, name in ipairs(enabled_lsps) do
        local cmd = vim.lsp.config[name].cmd
        if type(cmd) == 'table' then
          vim.lsp.config(name, { cmd = { 'lsp-devtools', 'agent', '--', unpack(cmd) } })
        end
      end
      vim.lsp.enable(enabled_lsps)
    end,
  })
else
  vim.lsp.enable(enabled_lsps)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp_setup', {}),
  desc = 'LSP setup',
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client:supports_method('textDocument/codeLens') then
      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost', 'CursorHold' }, {
        group = vim.api.nvim_create_augroup('lsp_codelens_refresh' .. args.buf, {}),
        buffer = args.buf,
        desc = 'Refresh codelenses',
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = args.buf })
        end,
      })
    end
  end,
})

local last_progress_echo_secs = 0
---@alias LSPWorkDoneProgress lsp.WorkDoneProgressBegin|lsp.WorkDoneProgressReport|lsp.WorkDoneProgressEnd
---@class LspProgressCallbackArgs : vim.api.keyset.create_autocmd.callback_args
---@field data {client_id:integer, params:{value:LSPWorkDoneProgress}}
vim.api.nvim_create_autocmd('LspProgress', {
  group = vim.api.nvim_create_augroup('lsp_progress_echo', {}),
  desc = 'Update g:statusline_lsp and redraw status line',
  ---@param args LspProgressCallbackArgs
  callback = function(args)
    -- Debounce echoes to no more than 1/ms because vim._extui doesn't handle multiple messages in quick succession very
    -- nicely.
    local progress = args.data.params.value
    local secs_since_last_echo = os.clock() - last_progress_echo_secs
    if secs_since_last_echo < 0.001 then
      if progress.kind == 'end' then
        -- We always want to show the 'end' progress update so just wait 1ms.
        vim.wait(1)
      else
        return
      end
    end

    local msg = progress.message or ''
    local status = 'running'
    local percent = progress.percentage
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local title = string.format('[%s] %s', client.name, progress.title)
    if progress.kind == 'end' then
      msg = 'done'
      status = 'success'
    end

    vim.api.nvim_echo({ { msg } }, false, { id = title, kind = 'progress', status = status, percent = percent, title = title })
    last_progress_echo_secs = os.clock()
  end,
})

if vim.env.NVIM_DISABLE_LSP_LOGGING == 'true' then
  vim.lsp.log.set_level(vim.log.levels.OFF)
end
if vim.env.NVIM_LSP_LOG_LEVEL then
  vim.lsp.log.set_level(vim.env.NVIM_LSP_LOG_LEVEL)
end

vim.keymap.set('n', 'grl', vim.lsp.codelens.run, { desc = 'vim.lsp.codelens.run()' })
vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format, { desc = 'vim.lsp.buf.format()' })
