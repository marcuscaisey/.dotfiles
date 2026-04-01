vim.lsp.enable({
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
})

if vim.env.NVIM_ENABLE_LSP_DEVTOOLS == 'true' then
    vim.schedule(function()
        for _, config in ipairs(vim.lsp.get_configs({ enabled = true })) do
            local cmd = config.cmd
            if type(cmd) == 'table' then
                vim.lsp.config(config.name, { cmd = { 'lsp-devtools', 'agent', '--', unpack(cmd) } })
            end
        end
    end)
end

vim.lsp.codelens.enable()

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp.completion', {}),
    desc = 'Enable completion if the server supports it',
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, {
                convert = function(item)
                    return { kind_hlgroup = 'LspKind' .. vim.lsp.protocol.CompletionItemKind[item.kind] }
                end,
            })
            vim.bo[ev.buf].complete = 'o'
        end
    end,
})

vim.api.nvim_create_autocmd('LspProgress', {
    group = vim.api.nvim_create_augroup('lsp.progress_echo', {}),
    desc = 'Echo progress message',
    callback = function(ev)
        local value = ev.data.params.value
        vim.api.nvim_echo({ { value.message or 'done' } }, false, {
            id = 'lsp',
            kind = 'progress',
            source = 'vim.lsp',
            title = value.title,
            status = value.kind ~= 'end' and 'running' or 'success',
            percent = value.percentage,
        })
    end,
})

vim.api.nvim_create_user_command('LspLog', 'execute "tabnew " . luaeval("vim.lsp.log.get_filename()")', {})

vim.keymap.set('n', '<Leader>f', '<Cmd>lua vim.lsp.buf.format()<CR>', { desc = 'Format buffer' })
