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
    renderers = {
      directory = {
        { 'indent' },
        { 'icon' },
        { 'current_filter' },
        { 'name' },
        {
          'symlink_target',
          highlight = 'NeoTreeSymbolicLinkTarget',
        },
        { 'clipboard' },
        { 'git_status' },
      },
      file = {
        { 'indent' },
        { 'icon' },
        {
          'name',
          use_git_status_colors = true,
        },
        {
          'symlink_target',
          highlight = 'NeoTreeSymbolicLinkTarget',
        },
        { 'clipboard' },
        { 'git_status' },
      },
    },
  },
}
