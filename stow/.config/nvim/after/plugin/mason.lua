local ok, mason = pcall(require, 'mason')
if not ok then
  return
end

mason.setup()

local tools = {
  'basedpyright',
  'bash-language-server',
  'black',
  'clangd',
  'efm',
  'eslint-lsp',
  'golangci-lint-langserver',
  'gopls',
  'intelephense',
  'json-lsp',
  'lua-language-server',
  'marksman',
  'prettierd',
  'stylua',
  'typescript-language-server',
  'vim-language-server',
}

vim.api.nvim_create_user_command('MasonInstallTools', function()
  vim.cmd.MasonInstall({ args = tools })
end, { desc = 'Install all tools with mason', force = true })
