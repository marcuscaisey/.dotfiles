local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  return
end
local util = require('lspconfig.util')
local ok, blink = pcall(require, 'blink.cmp')
if not ok then
  return
end
local ok, neodev = pcall(require, 'neodev')
if not ok then
  return
end


util.default_config = vim.tbl_deep_extend('force', util.default_config, {
  capabilities = blink.get_lsp_capabilities(),
})

neodev.setup({
  override = function(root_dir, library)
    if vim.uv.fs_stat(vim.fs.joinpath(root_dir, '.luarc.json')) then
      library.enabled = false
    end
  end,
})

lspconfig.lua_ls.setup({
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
      workspace = {
        checkThirdParty = false,
      },
    },
  },
})

vim.keymap.set('n', '<Leader>rl', '<Cmd>LspRestart<CR>')
