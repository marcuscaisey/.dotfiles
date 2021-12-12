local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'
local util = require 'lspconfig.util'
local fn = vim.fn
local highlight = vim.highlight
local api = vim.api

lspconfig.gopls.setup {
  flags = {debounce_text_changes = 150},
  settings = {gopls = {directoryFilters = {'-plz-out'}}},
  root_dir = function(fname) return fn.getcwd() end
}

lspconfig.pyright.setup {
  flags = {debounce_text_changes = 150},
  root_dir = function(fname) return fn.getcwd() end,
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
}

lspconfig.vimls.setup {}

lspconfig.ccls.setup {root_dir = function() return fn.getcwd() end}

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

lspconfig.please.setup {}

lspconfig.yamlls.setup {}

lspconfig.bashls.setup {}

lspconfig.intelephense.setup {}

lspconfig.tsserver.setup {root_dir = function() return fn.getcwd() end}

lspconfig.jsonls.setup {}

-- Use icons in theme colour for error / warning signs
fn.sign_define('DiagnosticSignError',
               {text = '', texthl = 'LspDiagnosticsError'})
fn.sign_define('DiagnosticSignWarn',
               {text = '', texthl = 'LspDiagnosticsWarning'})
fn.sign_define('DiagnosticSignHint',
               {text = '', texthl = 'LspDiagnosticsHint'})

-- Use theme colours for diagnostic highlights
highlight.link('DiagnosticError', 'LspDiagnosticsError', true)
highlight.link('DiagnosticWarn', 'LspDiagnosticsWarning', true)
highlight.link('DiagnosticHint', 'LspDiagnosticsHint', true)
