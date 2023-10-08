local ok, configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  return
end

configs.setup({
  ensure_installed = {
    'comment',
    'git_rebase',
    'gitcommit',
    'go',
    'gomod',
    'gosum',
    'gowork',
    'ebnf',
    'html',
    'java',
    'javascript',
    'json',
    'perl',
    'php',
    'promql',
    'proto',
    'regex',
    'ruby',
    'scheme',
    'sql',
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
        ['iC'] = '@class.inner',
        ['aC'] = '@class.outer',
        ['iv'] = '@value.inner',
        ['av'] = '@value.outer',
      },
      selection_modes = {
        ['@function.outer'] = 'V',
        ['@function.inner'] = 'V',
        ['@class.outer'] = 'V',
        ['@class.inner'] = 'V',
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
  autotag = {
    enable = true,
    enable_close = true,
    enable_rename = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
})
