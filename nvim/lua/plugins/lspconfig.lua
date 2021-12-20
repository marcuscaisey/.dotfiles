local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'
local cmp_nvim_lsp = require 'cmp_nvim_lsp'
local fn = vim.fn
local api = vim.api

local servers = {
  gopls = {
    settings = {gopls = {directoryFilters = {'-plz-out'}}},
    root_dir = function() return fn.getcwd() end
  },
  pyright = {
    root_dir = function() return fn.getcwd() end,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = 'workspace',
          useLibraryCodeForTypes = true,
          extraPaths = {
            '/home/mcaisey/core3/src', '/home/mcaisey/core3/src/plz-out/gen'
          }
        }
      }
    }
  },
  yamlls = {},
  vimls = {},
  ccls = {root_dir = function() return fn.getcwd() end},
  please = {},
  bashls = {},
  intelephense = {},
  tsserver = {root_dir = function() return fn.getcwd() end},
  jsonls = {}
}

local system_name
if fn.has('mac') == 1 then
  system_name = 'macOS'
elseif fn.has('unix') == 1 then
  system_name = 'Linux'
elseif fn.has('win32') == 1 then
  system_name = 'Windows'
else
  print('Unsupported system for sumneko')
end

local sumneko_root_path = '/opt/lua-language-server'
local sumneko_binary = sumneko_root_path .. '/bin/' .. system_name ..
                           '/lua-language-server'

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

lspconfig.sumneko_lua.setup {
  cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'},
  settings = {
    Lua = {
      runtime = {version = 'LuaJIT', path = runtime_path},
      diagnostics = {globals = {'vim'}},
      workspace = {library = api.nvim_get_runtime_file('', true)}
    }
  }
}

configs.please = {
  default_config = {
    cmd = {'plz', 'tool', 'lps'},
    filetypes = {'please'},
    root_dir = util.root_pattern('.plzconfig')
  }
}

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol
                                                          .make_client_capabilities())
for server, config in pairs(servers) do
  lspconfig[server].setup {
    capabilities = capabilities,
    flags = {debounce_text_changes = 150},
    settings = config.settings,
    root_dir = config.root_dir
  }
end
