local g = vim.g
local tree_cb = require('nvim-tree.config').nvim_tree_callback
local nvim_tree = require 'nvim-tree'
local cmd = vim.cmd

g.nvim_tree_quit_on_open = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_highlight_opened_files = 1
g.nvim_tree_group_empty = 1
g.nvim_tree_respect_buf_cwd = 1

nvim_tree.setup {
  auto_close = true,
  hide_dotfiles = true,
  ignore = { '.git' },
  update_focused_file = {
    enable = true,
  },
  filters = {
    dotfiles = false,
    custom = {
      '.git',
      '__pycache__',
      '.mypy_cache',
    },
  },
  view = {
    width = '25%',
    mappings = {
      list = {
        {
          key = 'h',
          cb = tree_cb 'close_node',
        },
        {
          key = 'l',
          cb = tree_cb 'edit',
        },
        {
          key = '<c-]>',
          cb = ':lua NvimTreeCD() <cr>',
        },
      },
    },
  },
}

--- Changes the NvimTree cwd and changes the nvim cwd to that as well
function NvimTreeCD()
  nvim_tree.on_keypress 'cd'
  cmd('cd ' .. require('nvim-tree.lib').Tree.cwd)
end
