require('nvim-treesitter.configs').setup({
  ensure_installed = { 'lua', 'python', 'go', 'json', 'yaml', 'query', 'comment', 'markdown', 'vim', 'html' },
  highlight = {
    enable = true,
    disable = { 'yaml' },
  },
  indent = { enable = false },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'grn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
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
        ['iC'] = '@class.inner',
        ['aC'] = '@class.outer',
        ['iv'] = '@literal_value',
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
      },
      goto_next_end = {
        [']F'] = '@function.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[a'] = '@parameter.inner',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
      },
    },
  },
  playground = {
    enable = true,
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { 'BufWrite', 'CursorHold' },
  },
  autotag = {
    enable = true,
    enable_close = true,
    enable_rename = true,
  },
})

require('treesitter-context').setup()
