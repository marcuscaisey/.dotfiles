local nvim_tree = require 'nvim-tree'
local view = require 'nvim-tree.view'
local lib = require 'nvim-tree.lib'

vim.g.nvim_tree_quit_on_open = 1
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_respect_buf_cwd = 1

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
          action = 'close_node',
        },
        {
          key = 'l',
          action = 'edit_in_place',
        },
        {
          key = '<CR>',
          action = 'edit_in_place',
        },
      },
    },
  },
}

vim.cmd 'augroup nvim_tree'
vim.cmd '  autocmd!'
vim.cmd '  autocmd BufEnter NvimTree NvimTreeRefresh'
vim.cmd 'augroup END'

local function open_replacing_current_buffer()
  if view.is_visible() then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(buf)

  local cwd
  if bufname ~= '' then
    cwd = vim.fn.fnamemodify(bufname, ':p:h')
  else
    cwd = vim.loop.cwd()
  end
  if not TreeExplorer or cwd ~= TreeExplorer.cwd then
    lib.init(cwd)
  end
  view.open_in_current_win { hijack_current_buf = false, resize = false }
  require('nvim-tree.renderer').draw()
end

local function toggle_replace()
  if view.is_visible() then
    view.close()
  else
    open_replacing_current_buffer()
  end
end

local M = {
  toggle_replace = toggle_replace,
}

return M
