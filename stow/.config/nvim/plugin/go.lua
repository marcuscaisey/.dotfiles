local protocol = require('vim.lsp.protocol')

local group = vim.api.nvim_create_augroup('go', { clear = true })

vim.api.nvim_create_autocmd('BufWritePost', {
  group = group,
  pattern = { '*.go' },
  desc = 'Run puku on saved file',
  callback = function(args)
    if not vim.fs.root(args.match, '.plzconfig') then
      return
    end
    vim.system({ 'puku', 'fmt', args.match }, nil, function(res)
      local output = res.code == 0 and vim.trim(res.stdout) or vim.trim(res.stderr)
      if output ~= '' then
        vim.schedule(function()
          vim.notify('puku: ' .. output, vim.log.levels.INFO)
        end)
      end
    end)
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
