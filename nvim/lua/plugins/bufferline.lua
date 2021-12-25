require('bufferline').setup {
  highlights = {
    buffer_selected = {
      gui = 'bold',
    },
    duplicate_selected = {
      gui = 'bold',
    },
    duplicate = {
      gui = '',
    },
  },
  options = {
    max_name_length = 30,
    tab_size = 12,
    show_buffer_close_icons = false,
    show_close_icon = false,
  },
}
