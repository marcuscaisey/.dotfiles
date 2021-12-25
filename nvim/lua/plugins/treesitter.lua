local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
local configs = require 'nvim-treesitter.configs'
parser_config.python.used_by = 'please'

configs.setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
    disable = { 'yaml' },
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'grn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true,
    disable = { 'yaml', 'python' },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ia'] = '@parameter.inner',
        ['aa'] = '@parameter.outer',
        ['ic'] = '@call.inner',
        ['ac'] = '@call.outer',
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        [']f'] = '@function.outer',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
      },
    },
  },
}

require('treesitter-context').setup()
