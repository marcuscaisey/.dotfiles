require('nvim-treesitter.configs').setup {
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
        ['ac'] = '@call.outer'
      }
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {[']f'] = '@function.outer'},
      goto_next_end = {[']F'] = '@function.outer'},
      goto_previous_start = {['[f'] = '@function.outer'},
      goto_previous_end = {['[F'] = '@function.outer'}
    }
  }
}
