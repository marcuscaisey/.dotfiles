require('neo-tree').setup {
  use_popups_for_input = false,
  enable_diagnostics = false,
  default_component_configs = {
    indent = {
      with_markers = true,
    },
  },
  filesystem = {
    use_libuv_file_watcher = true,
    window = {
      position = 'split',
      mappings = {
        ['l'] = 'open',
        ['h'] = 'close_node',
        ['-'] = 'navigate_up',
      },
    },
  },
}
