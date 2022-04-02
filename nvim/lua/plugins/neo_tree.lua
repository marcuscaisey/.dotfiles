vim.g.neo_tree_remove_legacy_commands = 1

require('neo-tree').setup {
  use_popups_for_input = false,
  enable_git_status = true,
  git_status_async = true,
  default_component_configs = {
    indent = {
      with_markers = false,
    },
    icon = {
      folder_closed = '',
      folder_open = '',
      folder_empty = '',
      default = '*',
    },
    name = {
      use_git_status_colors = true,
    },
  },
  window = {
    position = 'current',
  },
  filesystem = {
    window = {
      mappings = {
        ['l'] = 'open',
        ['h'] = 'close_node',
        ['-'] = 'navigate_up',
        ['<c-]>'] = 'set_root',
        ['.'] = function(state)
          vim.api.nvim_set_current_dir(state.path)
          print(string.format('cwd set to %s', state.path))
        end,
      },
    },
    renderers = {
      directory = {
        { 'indent' },
        { 'icon' },
        { 'current_filter' },
        { 'name' },
        { 'symlink_target', highlight = 'NeoTreeSymbolicLinkTarget' },
        { 'clipboard' },
      },
      file = {
        { 'indent' },
        { 'icon' },
        { 'name' },
        { 'symlink_target', highlight = 'NeoTreeSymbolicLinkTarget' },
        { 'clipboard' },
      },
    },
    bind_to_cwd = false,
    use_libuv_file_watcher = true,
  },
}
