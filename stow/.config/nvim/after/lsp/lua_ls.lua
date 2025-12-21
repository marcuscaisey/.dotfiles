---@type vim.lsp.Config
return {
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
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
  ---@diagnostic disable-next-line: unused-local
  before_init = function(params, config)
    if
      config.root_dir
      and (vim.uv.fs_stat(vim.fs.joinpath(config.root_dir, '.luarc.json')) or vim.uv.fs_stat(vim.fs.joinpath(config.root_dir, '.luarc.jsonc')))
    then
      return
    end

    local config_dir = vim.fn.stdpath('config')
    ---@diagnostic disable-next-line: param-type-mismatch
    config.settings.Lua = vim.tbl_deep_extend('force', config.settings.Lua, {
      runtime = {
        pathStrict = true,
        version = 'LuaJIT',
      },
      workspace = {
        library = vim.tbl_filter(function(path)
          return not vim.startswith(path, config_dir)
        end, vim.api.nvim_get_runtime_file('lua', true)),
      },
    })
  end,
}
