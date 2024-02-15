local protocol = require('vim.lsp.protocol')

local group = vim.api.nvim_create_augroup('go', { clear = true })

local puku_enabled = true

vim.api.nvim_create_user_command('PukuToggle', function()
  if puku_enabled then
    puku_enabled = false
    vim.notify('Disabled puku auto-formatting', vim.log.levels.INFO)
  else
    puku_enabled = true
    vim.notify('Enabled puku auto-formatting', vim.log.levels.INFO)
  end
end, {
  desc = 'Toggle puku auto-formatting',
})

vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  pattern = { '*.go' },
  desc = 'Run puku on saved file if enabled',
  callback = function(args)
    if
      not puku_enabled
      or #vim.fs.find('.plzconfig', { upward = true, path = vim.api.nvim_buf_get_name(args.buf) }) < 1
    then
      return
    end
    local function on_event(_, data)
      local msg = table.concat(data, '\n')
      msg = vim.trim(msg)
      msg = msg:gsub('\t', string.rep(' ', 4))
      if msg ~= '' then
        vim.notify('puku: ' .. msg, vim.log.levels.INFO)
      end
    end
    vim.fn.jobstart({ 'puku', 'fmt', args.file }, {
      on_stdout = on_event,
      on_stderr = on_event,
      stdout_buffered = true,
      stderr_buffered = true,
    })
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = group,
  pattern = '*.go',
  desc = 'Organize imports on save',
  callback = function(args)
    local params = vim.lsp.util.make_range_params() ---@type lsp.CodeActionParams
    params.context = {
      diagnostics = {},
      only = { 'source.organizeImports' },
    }
    local result = vim.lsp.buf_request_sync(args.buf, protocol.Methods.textDocument_codeAction, params)
    for client_id, err_or_result in pairs(result or {}) do
      for _, code_action in pairs(err_or_result.result or {}) do
        ---@cast code_action lsp.CodeAction
        if code_action.edit then
          local offset_encoding = vim.lsp.get_client_by_id(client_id).offset_encoding or 'utf-16'
          vim.lsp.util.apply_workspace_edit(code_action.edit, offset_encoding)
        end
      end
    end
  end,
})
