local lspconfig = require 'lspconfig'
local configs = require 'lspconfig/configs'
local util = require 'lspconfig.util'
local fn = vim.fn
local highlight = vim.highlight
local cmd = vim.cmd
local api = vim.api

lspconfig.gopls.setup{
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    gopls = {
      directoryFilters = {'-plz-out'},
    },
  },
  root_dir = function(fname)
    return fn.getcwd()
  end,
}

lspconfig.pyright.setup{
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        extraPaths = {
          "/home/mcaisey/core3/src",
          "/home/mcaisey/core3/src/plz-out/gen",
        }
      },
    },
  },
}

lspconfig.vimls.setup{}

lspconfig.ccls.setup{}

local system_name
if fn.has("mac") == 1 then
  system_name = "macOS"
elseif fn.has("unix") == 1 then
  system_name = "Linux"
elseif fn.has("win32") == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

local sumneko_root_path = "/opt/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/" .. system_name .. "/lua-language-server"

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = runtime_path,
      },
      diagnostics = {
        globals = {"vim"},
      },
      workspace = {
        library = api.nvim_get_runtime_file("", true),
      },
    },
  },
}

configs.please = {
  default_config = {
    cmd = {'plz', 'tool', 'lps'},
    filetypes = {'please'},
    root_dir = util.root_pattern('.plzconfig'),
  },
}

lspconfig.please.setup{}

lspconfig.yamlls.setup{}

-- Use icons in theme colour for error / warning signs
fn.sign_define('LspDiagnosticsSignError', {text = '', texthl = 'LspDiagnosticsError'})
fn.sign_define('LspDiagnosticsSignWarning', {text = '', texthl = 'LspDiagnosticsWarning'})
fn.sign_define('LspDiagnosticsSignHint', {text = '', texthl = 'LspDiagnosticsHint'})

-- LspDiagnosticsError, LspDiagnosticsWarning are linked to theme groups so link default groups to them as well
highlight.link('LspDiagnosticsDefaultError', 'LspDiagnosticsError', true)
highlight.link('LspDiagnosticsDefaultWarning', 'LspDiagnosticsWarning', true)
highlight.link('LspDiagnosticsDefaultHint', 'LspDiagnosticsHint', true)

-- Autoformat go files on save
cmd([[autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)]])

-- Organise go imports on save
cmd([[autocmd BufWritePre *.go lua goimports(1000)]])

-- copied from https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
function goimports(timeout_ms)
  local context = { only = { "source.organizeImports" } }
  vim.validate { context = { context, "t", true } }

  local params = vim.lsp.util.make_range_params()
  params.context = context

  -- See the implementation of the textDocument/codeAction callback
  -- (lua/vim/lsp/handler.lua) for how to do this properly.
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
  if not result or next(result) == nil then return end
  local actions = result[1].result
  if not actions then return end
  local action = actions[1]

  -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
  -- is a CodeAction, it can have either an edit, a command or both. Edits
  -- should be executed first.
  if action.edit or type(action.command) == "table" then
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit)
    end
    if type(action.command) == "table" then
      vim.lsp.buf.execute_command(action.command)
    end
  else
    vim.lsp.buf.execute_command(action)
  end
end
