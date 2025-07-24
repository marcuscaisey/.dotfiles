---@type vim.lsp.Config
return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'basic',
      },
    },
  },
  ---@diagnostic disable-next-line: unused-local
  before_init = function(params, config)
    if not config.root_dir then
      return
    end
    if vim.uv.fs_stat(vim.fs.joinpath(config.root_dir, '.plzconfig')) then
      ---@diagnostic disable-next-line: param-type-mismatch
      config.settings.basedpyright = vim.tbl_deep_extend('force', config.settings.basedpyright, {
        analysis = {
          extraPaths = {
            vim.fs.joinpath(config.root_dir, 'plz-out/python/venv'),
          },
          exclude = { 'plz-out' },
        },
      })
    end
  end,
}
