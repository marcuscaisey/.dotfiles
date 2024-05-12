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
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' }, -- Default excluding proto
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
      noSemanticString = true,
      codelenses = {
        gc_details = true,
      },
    },
  },
  root_dir = function(fname)
    local plzconfig_dir = util.root_pattern('.plzconfig')(fname)
    if plzconfig_dir and vim.fs.basename(plzconfig_dir) == 'src' then
      vim.env.GOPATH = string.format('%s:%s/plz-out/go', vim.fs.dirname(plzconfig_dir), plzconfig_dir)
      vim.env.GO111MODULE = 'off'
      return vim.fn.getcwd()
    end

    local gowork_or_gomod_dir = util.root_pattern('go.work', 'go.mod')(fname)
    if gowork_or_gomod_dir then
      return gowork_or_gomod_dir
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

lspconfig.intelephense.setup({})

lspconfig.jsonls.setup({})

lspconfig.marksman.setup({})

lspconfig.please.setup({})

lspconfig.pyright.setup({
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
        exclude = {
          'plz-out',
        },
      },
    },
  },
  root_dir = function(fname)
    if util.root_pattern('.plzconfig') then
      return vim.fn.getcwd()
    else
      return util.root_pattern(
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'pyrightconfig.json',
        '.git'
      )(fname)
    end
  end,
  on_new_config = function(config, root_dir)
    local plzconfig_dir = util.root_pattern('.plzconfig')(root_dir)
    if not plzconfig_dir then
      return
    end
    config.settings.python.analysis.extraPaths = {
      plzconfig_dir,
      vim.fs.joinpath(plzconfig_dir, 'plz-out/gen'),
      vim.fs.joinpath(plzconfig_dir, 'plz-out/python/venv'),
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
