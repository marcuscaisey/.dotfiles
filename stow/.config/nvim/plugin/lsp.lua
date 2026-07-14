vim.lsp.enable({
    'basedpyright',
    'bashls',
    'clangd',
    'dartls',
    'efm',
    'eslint',
    'fish_lsp',
    'golangci_lint_ls',
    'gopls',
    'intelephense',
    'jdtls',
    'jsonls',
    'loxls',
    'lua_ls',
    'marksman',
    'please',
    'rust_analyzer',
    'stylua',
    'ts_ls',
    'vimls',
    'yamlls',
})

if vim.env.NVIM_ENABLE_LSP_DEVTOOLS then
    for _, config in ipairs(vim.lsp.get_configs({ enabled = true })) do
        local cmd = config.cmd
        if type(cmd) == 'table' and (vim.env.NVIM_ENABLE_LSP_DEVTOOLS == config.name or vim.env.NVIM_ENABLE_LSP_DEVTOOLS == 'all') then
            vim.lsp.config(config.name, { cmd = { 'lsp-devtools', 'agent', '--', unpack(cmd) } })
        end
    end
end

vim.lsp.codelens.enable()

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Enable completion if the server supports it',
    group = vim.api.nvim_create_augroup('lsp.completion'),
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, {
                convert = function(item)
                    return { kind_hlgroup = 'LspKind' .. vim.lsp.protocol.CompletionItemKind[item.kind] }
                end,
                autotrigger = true,
            })
            vim.bo[ev.buf].complete = 'o'
        end
    end,
})

local original_formatexpr = vim.lsp.formatexpr
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.formatexpr = function(opts)
    original_formatexpr(vim.tbl_deep_extend('keep', opts or {}, { timeout_ms = 5000 }))
end

vim.api.nvim_create_autocmd('LspProgress', {
    desc = 'Echo progress message',
    group = vim.api.nvim_create_augroup('lsp.progress_echo'),
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

--- Copied from $VIMRUNTIME/runtime/lua/vim/lsp.lua
--- @param bufnr integer
--- @param config vim.lsp.Config
local function start_config(bufnr, config)
    return vim.lsp.start(config, {
        bufnr = bufnr,
        reuse_client = config.reuse_client,
        _root_markers = config.root_markers,
    })
end

vim.api.nvim_create_autocmd('FileType', {
    desc = "When 'filetype' is set to foo.gotmpl, start the servers for filetypes foo and gotmpl",
    group = vim.api.nvim_create_augroup('lsp.gotmpl_servers'),
    pattern = '*.gotmpl',
    callback = function(ev)
        for filetype in vim.gsplit(ev.match, '.', { plain = true }) do
            for _, config in ipairs(vim.lsp.get_configs({ enabled = true })) do
                if vim.list_contains(config.filetypes, filetype) then
                    vim.lsp.start(config, { bufnr = ev.buf })
                    if type(config.root_dir) == 'function' then
                        config.root_dir(ev.buf, function(root_dir)
                            config.root_dir = root_dir
                            vim.schedule(function()
                                start_config(ev.buf, config)
                            end)
                        end)
                    else
                        start_config(ev.buf, config)
                    end
                end
            end
        end
    end,
})

vim.keymap.set('n', '<Leader>f', '<Cmd>lua vim.lsp.buf.format()<CR>', { desc = 'Format buffer' })
