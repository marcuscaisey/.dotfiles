---@type vim.lsp.Config
return {
  settings = {
    gopls = {
      semanticTokens = true,
      semanticTokenTypes = {
        string = false,
      },
    },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('gopls_organize_imports' .. bufnr, {}),
      buffer = bufnr,
      desc = 'Run gopls source.organizeImports code action',
      callback = function()
        local params = vim.lsp.util.make_range_params(0, client.offset_encoding) ---@type lsp.CodeActionParams
        params.context = { only = { 'source.organizeImports' }, diagnostics = {} }
        local resp = client:request_sync('textDocument/codeAction', params, nil, bufnr)
        if not resp or not resp.result then
          return
        end
        for _, code_action in pairs(resp.result) do
          if code_action.edit then
            vim.lsp.util.apply_workspace_edit(code_action.edit, client.offset_encoding)
          end
        end
      end,
    })
  end,
}
