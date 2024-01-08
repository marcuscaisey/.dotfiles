local ok, configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  return
end

local parsers = require('nvim-treesitter.parsers')
local parser_configs = parsers.get_parser_configs()
---@diagnostic disable-next-line: inject-field
parser_configs.lox = {
  install_info = {
    url = 'https://github.com/marcuscaisey/tree-sitter-lox',
    files = { 'src/parser.c' },
  },
}

---@diagnostic disable-next-line: missing-fields
configs.setup({
  ensure_installed = {
    'bash',
    'c',
    'comment',
    'dart',
    'git_rebase',
    'gitcommit',
    'go',
    'gomod',
    'gosum',
    'gowork',
    'html',
    'java',
    'javascript',
    'json',
    'lua',
    'markdown',
    'lox',
    'perl',
    'php',
    'promql',
    'proto',
    'python',
    'query',
    'regex',
    'ruby',
    'scheme',
    'sql',
    'terraform',
    'typescript',
    'vim',
    'vimdoc',
    'yaml',
  },
  highlight = {
    enable = true,
    disable = { 'yaml' },
  },
  indent = { enable = false },
  textobjects = {
    select = {
      enable = true,
      lookahead = false,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ia'] = '@parameter.inner',
        ['aa'] = '@parameter.outer',
        ['ic'] = '@call.inner',
        ['ac'] = '@call.outer',
        ['iv'] = '@value.inner',
        ['av'] = '@value.outer',
      },
      selection_modes = {
        ['@function.outer'] = 'V',
        ['@function.inner'] = 'V',
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        [']f'] = '@function.outer',
        [']a'] = '@parameter.inner',
        [']m'] = '@method.outer',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
        [']M'] = '@method.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[a'] = '@parameter.inner',
        ['[m'] = '@method.outer',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[M'] = '@method.outer',
      },
    },
  },
})
