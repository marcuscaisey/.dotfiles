local lspconfig = require 'lspconfig'
local util = require 'lspconfig.util'

local system_name
if vim.fn.has 'mac' == 1 then
  system_name = 'macOS'
elseif vim.fn.has 'unix' == 1 then
  system_name = 'Linux'
elseif vim.fn.has 'win32' == 1 then
  system_name = 'Windows'
else
  print 'Unsupported system for sumneko'
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

-- Don't add ~/.config/nvim to the LSP libraries because that's just a symlink
-- to ~/.dotfiles/nvim/lua, so when we're in ~/.dotfiles/nvim/lua we end up
-- with duplicate symbols
local runtime_files = vim.api.nvim_get_runtime_file('', true)
local config_dir = vim.fn.expand '~/.config/nvim'
local lua_library = {}
for _, file in ipairs(runtime_files) do
  if file:sub(1, #config_dir) ~= config_dir then
    table.insert(lua_library, file)
  end
end

lspconfig.sumneko_lua.setup {
  cmd = { 'lua-language-server' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = lua_library,
      },
    },
  },
}

require('lspconfig.configs').please = {
  default_config = {
    cmd = { 'plz', 'tool', 'lps' },
    filetypes = { 'please' },
    root_dir = util.root_pattern '.plzconfig',
  },
}

local servers = {
  gopls = {
    settings = {
      gopls = {
        directoryFilters = { '-plz-out' },
        linksInHover = false,
      },
    },
    root_dir = function(fname)
      local go_mod_root = util.root_pattern 'go.mod'(fname)
      if go_mod_root then
        return go_mod_root
      end
      local plz_root = util.root_pattern '.plzconfig'(fname)
      local gopath_root = util.root_pattern 'src'(fname)
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

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
for server, config in pairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    settings = config.settings,
    root_dir = config.root_dir,
    cmd = config.cmd,
  }
end

vim.diagnostic.config {
  virtual_text = false,
  float = {
    source = 'always',
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}
