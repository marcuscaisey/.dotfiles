---@type vim.lsp.Config
return {
    settings = {
        emmylua = {
            codeLens = { enable = false },
            format = {
                externalTool = {
                    program = 'stylua',
                    args = {
                        '--stdin-filepath=${file}',
                        '-',
                    },
                },
            },
        },
    },
    root_markers = {
        { '.emmyrc.json', '.emmyrc.lua', '.luarc.json', '.luarc.jsonc' },
        { 'lua' },
        { '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml' },
        { '.git' },
    },
    before_init = function(_params, config)
        if not config.root_dir then
            return
        end
        for _, config_file_name in ipairs({ '.emmyrc.json', '.emmyrc.lua', '.luarc.json', '.luarc.jsonc' }) do
            if vim.uv.fs_stat(vim.fs.joinpath(config.root_dir, config_file_name)) then
                return
            end
        end

        local config_stdpath = vim.fn.stdpath('config')
        ---@cast config_stdpath string
        local config_dir = assert(vim.uv.fs_realpath(config_stdpath))
        local plugin_name = vim.fs.basename(config.root_dir)
        if not config.settings or not config.settings.emmylua then
            return
        end
        ---@diagnostic disable-next-line: assign-type-mismatch, param-type-mismatch, generic-constraint-mismatch
        config.settings.emmylua = vim.tbl_deep_extend('force', config.settings.emmylua, {
            runtime = {
                requirePattern = { '?.lua', '?/init.lua', './lua/?.lua', './lua/?/init.lua' },
                version = 'LuaJIT',
            },
            workspace = {
                library = vim.tbl_filter(function(path)
                    path = assert(vim.uv.fs_realpath(path))
                    if vim.fs.relpath(config_dir, path) then
                        return false
                    end
                    if config.root_dir ~= config_dir and vim.fs.basename(path) == 'lua' and vim.fs.basename(vim.fs.dirname(path)) == plugin_name then
                        return false
                    end
                    return true
                end, vim.api.nvim_get_runtime_file('lua', true)),
            },
        })
    end,
}
