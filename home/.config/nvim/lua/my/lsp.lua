vim.lsp.enable({
    'basedpyright',
    'bashls',
    'clangd',
    'dartls',
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
    'oxfmt',
    'please',
    'ruff',
    'rust_analyzer',
    'stylua',
    'ts_ls',
    'vimls',
    'yamlls',
    'zls',
})

vim.lsp.codelens.enable()

local original_formatexpr = vim.lsp.formatexpr
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.formatexpr = function(opts)
    original_formatexpr(vim.tbl_deep_extend('keep', opts or {}, { timeout_ms = 5000 }))
end

vim.api.nvim_create_autocmd('LspProgress', {
    desc = 'Echo progress message',
    group = vim.api.nvim_create_augroup('my.lsp.progress_echo'),
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
    group = vim.api.nvim_create_augroup('my.lsp.gotmpl_servers'),
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

---@return integer
local function free_port()
    local tcp = assert(vim.uv.new_tcp())
    -- Binding to port 0 lets the OS assign an ephemeral port
    tcp:bind('127.0.0.1', 0)
    local port = tcp:getsockname().port
    tcp:shutdown()
    tcp:close()
    return port
end

---@param msg string
---@param ... any
local function echo_error(msg, ...)
    local formatted_msg = string.format('LspInspect: %s', string.format(msg, ...))
    vim.api.nvim_echo({ { formatted_msg } }, true, { err = true })
end

vim.api.nvim_create_user_command('LspInspect', function(args)
    local name = args.args
    local client = vim.lsp.get_clients({ name = name })[1]
    if not client then
        echo_error('no client named %s', name)
        return
    end

    if vim.fn.executable('lsp-devtools') == 0 then
        echo_error('lsp-devtools executable not found')
        return
    end
    local port = free_port()
    vim.cmd('vertical terminal lsp-devtools inspect --port ' .. port)
    vim.keymap.set('t', '<C-W>h', '<C-\\><C-N><C-W>h', { buf = 0 })
    vim.api.nvim_create_autocmd('BufEnter', { command = 'startinsert', buf = 0 })
    vim.cmd('wincmd p')

    client:stop()

    ---@param original_cmd string[]
    ---@return string[]
    local function agent_cmd(original_cmd)
        return { 'lsp-devtools', 'agent', '--port', port, '--', unpack(original_cmd) }
    end
    local config = vim.deepcopy(client.config)
    if type(config.cmd) == 'function' then
        local original_start = vim.lsp.rpc.start
        --- @param cmd string[] Command to start the LSP server.
        --- @param dispatchers? vim.lsp.rpc.Dispatchers
        --- @param extra_spawn_params? vim.net.transport.ExtraSpawnParams
        --- @return vim.lsp.rpc.Client
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.lsp.rpc.start = function(cmd, dispatchers, extra_spawn_params)
            local agent_cmd = agent_cmd(cmd)
            local result = original_start(agent_cmd, dispatchers, extra_spawn_params)
            vim.lsp.rpc.start = original_start
            return result
        end
    else
        local cmd = config.cmd
        ---@cast cmd string[]
        config.cmd = agent_cmd(cmd)
    end
    vim.lsp.start(config)
end, {
    desc = 'Inspect LSP traffic to/from a language server',
    nargs = 1,
    ---@param arg_lead string
    complete = function(arg_lead)
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        return vim
            .iter(clients)
            ---@param client vim.lsp.Client
            :map(function(client)
                return client.name
            end)
            ---@param name string
            :filter(function(name)
                return vim.startswith(name, arg_lead)
            end)
            :totable()
    end,
})
