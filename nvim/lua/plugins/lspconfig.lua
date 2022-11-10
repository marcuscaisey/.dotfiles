local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

require('lspconfig.configs').please = {
  default_config = {
    cmd = { 'plz', 'tool', 'lps' },
    filetypes = { 'please' },
    root_dir = util.root_pattern('.plzconfig'),
  },
}

local servers = {
  gopls = {
    settings = {
      gopls = {
        directoryFilters = { '-plz-out' },
        linksInHover = false,
        analyses = {
          unusedparams = true,
        },
        codelenses = {
          gc_details = true,
        },
        staticcheck = true,
      },
    },
    on_attach = function(_, bufnr)
      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost', 'CursorHold' }, {
        callback = vim.lsp.codelens.refresh,
        group = vim.api.nvim_create_augroup('gopls', { clear = true }),
        buffer = bufnr,
        desc = 'Refresh codelenses when gopls is running',
      })
    end,
    root_dir = function(fname)
      local go_mod_root = util.root_pattern('go.mod')(fname)
      if go_mod_root then
        return go_mod_root
      end
      local plz_root = util.root_pattern('.plzconfig')(fname)
      local gopath_root = util.root_pattern('src')(fname)
      if plz_root and gopath_root then
        vim.env.GOPATH = string.format('%s:%s/plz-out/go', gopath_root, plz_root)
        vim.env.GO111MODULE = 'off'
      end
      return vim.fn.getcwd()
    end,
  },
  pyright = {
    root_dir = function()
      return vim.fn.getcwd()
    end,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = 'workspace',
          useLibraryCodeForTypes = true,
          typeCheckingMode = 'off',
          extraPaths = {
            '/home/mcaisey/core3/src',
            '/home/mcaisey/core3/src/plz-out/gen',
          },
        },
      },
    },
  },
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
        },
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file('', true),
        },
        telemetry = {
          enable = false,
        },
        completion = {
          keywordSnippet = 'Disable',
        },
      },
    },
  },
  yamlls = {},
  vimls = {},
  ccls = {
    root_dir = function()
      return vim.fn.getcwd()
    end,
  },
  please = {},
  bashls = {},
  intelephense = {},
  tsserver = {
    root_dir = function()
      return vim.fn.getcwd()
    end,
  },
  jsonls = {},
  java_language_server = {
    cmd = { 'java_language_server.sh' },
  },
}

for server, config in pairs(servers) do
  lspconfig[server].setup({
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    flags = {
      debounce_text_changes = 150,
    },
    settings = config.settings,
    root_dir = config.root_dir,
    cmd = config.cmd,
    on_attach = config.on_attach,
  })
end

vim.diagnostic.config({
  virtual_text = false,
  float = {
    source = 'always',
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.lsp.set_log_level(vim.log.levels.OFF)

vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticInfo' })
vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticHint' })
