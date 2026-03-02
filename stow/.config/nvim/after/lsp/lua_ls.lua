---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      codeLens = {
        enable = false,
      },
      diagnostics = {
        disable = {
          'redefined-local',
        },
      },
      format = {
        enable = false,
      },
      workspace = {
        checkThirdParty = false,
      },
    },
  },
  root_markers = {
    { '.emmyrc.json', '.luarc.json', '.luarc.jsonc' },
    { 'lua' },
    { '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml' },
    { '.git' },
  },
  ---@diagnostic disable-next-line: unused-local
  before_init = function(params, config)
    if not config.root_dir then
      return
    end
    if vim.uv.fs_stat(vim.fs.joinpath(config.root_dir, '.luarc.json')) or vim.uv.fs_stat(vim.fs.joinpath(config.root_dir, '.luarc.jsonc')) then
      return
    end

    local plugin_name = vim.fs.basename(config.root_dir)
    local config_dir = vim.fn.stdpath('config')
    ---@diagnostic disable-next-line: param-type-mismatch
    config.settings.Lua = vim.tbl_deep_extend('force', config.settings.Lua, {
      runtime = {
        path = { '?.lua', '?/init.lua', './lua/?.lua', './lua/?/init.lua' },
        pathStrict = true,
        version = 'LuaJIT',
      },
      workspace = {
        library = vim.tbl_filter(function(path)
          return not vim.startswith(path, config_dir) and not vim.endswith(path, vim.fs.joinpath(plugin_name, 'lua'))
        end, vim.api.nvim_get_runtime_file('lua', true)),
      },
    })
  end,
}
