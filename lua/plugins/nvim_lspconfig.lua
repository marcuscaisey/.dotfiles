local lspconfig = require 'lspconfig'
local util = require 'lspconfig.util'
local fn = vim.fn
local highlight = vim.highlight
local cmd = vim.cmd

lspconfig.gopls.setup{
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    gopls = {
      directoryFilters = {'-plz-out'},
    },
  },
  root_dir = util.root_pattern("go.mod", ".git", "BUILD"),
}

lspconfig.pyright.setup{
  flags = {
    debounce_text_changes = 150,
  },
  root_dir = function(fname)
    local root_files = {
      'pyproject.toml',
      'setup.py',
      'setup.cfg',
      'requirements.txt',
      'Pipfile',
      'pyrightconfig.json',
      'BUILD',
    }
    return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
  end,
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

-- Use icons in theme colour for error / warning signs
fn.sign_define('LspDiagnosticsSignError', {text = '', texthl = 'LspDiagnosticsError'})
fn.sign_define('LspDiagnosticsSignWarning', {text = '', texthl = 'LspDiagnosticsWarning'})

-- LspDiagnosticsError and LspDiagnosticsWarning are linked to theme groups so link default groups to them as well
highlight.link('LspDiagnosticsDefaultError', 'LspDiagnosticsError', true)
highlight.link('LspDiagnosticsDefaultWarning', 'LspDiagnosticsWarning', true)

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
