local ok, mason = pcall(require, 'mason')
if not ok then
    return
end
local mason_registry = require('mason-registry')

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
    'jdtls',
    'json-lsp',
    'lua-language-server',
    'marksman',
    'prettierd',
    'stylua',
    'typescript-language-server',
    'vim-language-server',
    'yaml-language-server',
}

local args = {}
for _, tool in ipairs(tools) do
    if not mason_registry.is_installed(tool) then
        table.insert(args, tool)
    end
end
if #args > 0 then
    vim.cmd.MasonInstall({ args = args })
end
