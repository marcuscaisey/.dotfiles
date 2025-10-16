---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
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
  ---@diagnostic disable-next-line: unused-local
  before_init = function(params, config)
    if not config.root_dir then
      return
    end
    if vim.uv.fs_stat(vim.fs.joinpath(config.root_dir, '.luarc.json')) or vim.uv.fs_stat(vim.fs.joinpath(config.root_dir, '.luarc.jsonc')) then
      return
    end

    local config_dir = vim.fn.resolve(vim.fn.stdpath('config'))
    local library = vim.api.nvim_get_runtime_file('lua', true)
    if not vim.startswith(config_dir, config.root_dir) then
      library = vim.tbl_filter(function(path)
        return not vim.startswith(path, config_dir)
      end, library)
    end
    ---@diagnostic disable-next-line: param-type-mismatch
    config.settings.Lua = vim.tbl_deep_extend('force', config.settings.Lua, {
      runtime = {
        pathStrict = true,
        version = 'LuaJIT',
      },
      workspace = { library = library },
    })
  end,
}
