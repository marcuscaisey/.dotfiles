local g = vim.g
local tree_cb = require('nvim-tree.config').nvim_tree_callback

g.nvim_tree_ignore = {'.git'}
g.nvim_tree_hide_dotfiles = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_highlight_opened_files = 1
g.nvim_tree_group_empty = 1

require('nvim-tree').setup{
  auto_close = true,
  update_focused_file = {
    enable = true,
  },
  view = {
    width = '25%',
    mappings = {
      list = {
        {key = 'h', cb = tree_cb('close_node')},
        {key = 'l', cb = tree_cb("edit")},
      },
    },
  },
}
