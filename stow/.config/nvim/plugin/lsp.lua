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

        -- if client:supports_method('textDocument/completion') then
        --   vim.lsp.completion.enable(true, client.id, args.buf, {
        --     convert = function(item)
        --       return {
        --         menu = vim.tbl_get(item, 'labelDetails', 'detail') or '',
        --         kind_hlgroup = 'LspItemKind' .. vim.lsp.protocol.CompletionItemKind[item.kind],
        --       }
        --     end,
        --   })
        --   vim.bo[args.buf].complete = 'o'
        -- end

        if client:supports_method('textDocument/codeLens') then
            vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost', 'CursorHold' }, {
                group = vim.api.nvim_create_augroup('lsp_codelens_refresh' .. args.buf, {}),
                buffer = args.buf,
                desc = 'Refresh codelenses',
                command = 'lua vim.lsp.codelens.enable(true, { bufnr = 0 })',
            })
        end
    end,
})

vim.api.nvim_create_autocmd('LspProgress', {
    group = vim.api.nvim_create_augroup('lsp_progress_echo', {}),
    desc = 'Echo progress message',
    ---@class LspProgressCallbackArgs : vim.api.keyset.create_autocmd.callback_args
    ---@field data {client_id:integer, params:{value:lsp.WorkDoneProgressBegin|lsp.WorkDoneProgressReport|lsp.WorkDoneProgressEnd}}
    ---@param args LspProgressCallbackArgs
    callback = function(args)
        local value = args.data.params.value
        vim.api.nvim_echo({ { value.message or 'done' } }, false, {
            id = 'lsp',
            kind = 'progress',
            title = value.title,
            status = value.kind ~= 'end' and 'running' or 'success',
            percent = value.percentage,
        })
    end,
})

if vim.env.NVIM_DISABLE_LSP_LOGGING == 'true' then
    vim.lsp.log.set_level(vim.log.levels.OFF)
end
if vim.env.NVIM_LSP_LOG_LEVEL then
    vim.lsp.log.set_level(vim.env.NVIM_LSP_LOG_LEVEL)
end

vim.keymap.set('n', 'grl', '<Cmd>lua vim.lsp.codelens.run()<CR>')
vim.keymap.set('n', '<Leader>f', '<Cmd>lua vim.lsp.buf.format()<CR>')
