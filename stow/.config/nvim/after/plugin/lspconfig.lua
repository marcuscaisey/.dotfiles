local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  return
end
local configs = require('lspconfig.configs')
local util = require('lspconfig.util')
local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok then
  return
end
local ok, mason = pcall(require, 'mason')
if not ok then
  return
end
local ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not ok then
  return
end
local ok, neodev = pcall(require, 'neodev')
if not ok then
  return
end

mason.setup()
mason_lspconfig.setup({
  automatic_installation = true,
})

util.default_config = vim.tbl_deep_extend('force', util.default_config, {
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

configs.please = {
  default_config = {
    cmd = { 'plz', 'tool', 'lps' },
    filetypes = { 'please' },
    root_dir = util.root_pattern('.plzconfig'),
  },
}

lspconfig.autotools_ls.setup({})

lspconfig.bashls.setup({})

lspconfig.clangd.setup({
  cmd = { 'clangd', '--offset-encoding=utf-16' },
})

lspconfig.cmake.setup({})

lspconfig.dartls.setup({})

lspconfig.gopls.setup({
  settings = {
    gopls = {
      directoryFilters = { '-plz-out' },
      linksInHover = false,
      usePlaceholders = false,
      semanticTokens = true,
      codelenses = {
        gc_details = true,
      },
    },
  },
  root_dir = function(fname)
    local gowork_or_gomod_dir = util.root_pattern('go.work', 'go.mod')(fname)
    if gowork_or_gomod_dir then
      return gowork_or_gomod_dir
    end

    local plzconfig_dir = util.root_pattern('.plzconfig')(fname)
    if plzconfig_dir and vim.fs.basename(plzconfig_dir) == 'src' then
      vim.env.GOPATH = string.format('%s:%s/plz-out/go', vim.fs.dirname(plzconfig_dir), plzconfig_dir)
      vim.env.GO111MODULE = 'off'
    end

    return vim.fn.getcwd()
  end,
})

lspconfig.jdtls.setup({
  settings = {
    java = {
      referencesCodeLens = {
        enabled = false,
      },
    },
  },
})

lspconfig.golangci_lint_ls.setup({
  on_new_config = function(config)
    -- https://golangci-lint.run/usage/linters/#enabled-by-default
    local linters = { 'errcheck', 'gosimple', 'govet', 'ineffassign', 'staticcheck', 'unused' }
    for _, linter in ipairs(linters) do
      table.insert(config.init_options.command, '--enable')
      table.insert(config.init_options.command, linter)
    end
  end,
})

lspconfig.intelephense.setup({})

lspconfig.jsonls.setup({})

lspconfig.marksman.setup({})

lspconfig.please.setup({})

lspconfig.pylsp.setup({
  settings = {
    pylsp = {
      plugins = {
        autopep8 = { enabled = false },
        flake8 = { enabled = true },
        mccabe = { enabled = false },
        pycodestyle = { enabled = false },
        pyflakes = { enabled = false },
        yapf = { enabled = false },
        jedi_completion = { enabled = true },
      },
    },
  },
  on_new_config = function(config, root_dir)
    local plzconfig_dir = util.root_pattern('.plzconfig')(root_dir)
    if not plzconfig_dir then
      return
    end
    config.settings.pylsp.plugins.jedi = {
      extra_paths = {
        plzconfig_dir,
        vim.fs.joinpath(plzconfig_dir, 'plz-out/gen'),
      },
    }
  end,
})

neodev.setup({
  override = function(_, library)
    library.enabled = true
    library.plugins = true
  end,
})

lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false,
      },
      telemetry = {
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
    },
  },
})

lspconfig.rust_analyzer.setup({})

lspconfig.taplo.setup({})

lspconfig.tsserver.setup({
  on_attach = function(client)
    client.server_capabilities.documentFormattingProvider = false
  end,
})

lspconfig.vimls.setup({})

lspconfig.yamlls.setup({
  settings = {
    yaml = {
      validate = false,
    },
  },
})
