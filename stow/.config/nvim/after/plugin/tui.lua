local tui = require('tui-nvim')
local telescope_builtin = require('telescope.builtin')
local cwd = require('cwd')

local path_action = function(path_file, callback)
  return function()
    local file = io.open(path_file, 'r')
    if not file then
      return
    end
    local path = file:read()
    callback(path)
    os.remove(path_file)
  end
end

vim.keymap.set('n', '<c-f>', function()
  local cmd = 'vifm --choose-files /tmp/tui-nvim'
  local filename = vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
  if filename ~= '' then
    cmd = cmd .. ' --select ' .. filename
  end
  tui:new({
    cmd = cmd,
    temp = '/tmp/tui-nvim',
    method = 'edit',
    border = 'single',
    borderhl = 'FloatBorder',
    mappings = {
      { '<c-v>', ':!echo %c:p > /tmp/vifm-split<cr>:q<cr>' },
      { '<c-g>', ':!echo %d > /tmp/vifm-grep<cr>:q<cr>' },
      { '<c-c>', ':!echo %d > /tmp/vifm-cd<cr>:q<cr>' },
    },
    on_exit = {
      path_action('/tmp/vifm-split', function(path)
        vim.cmd.vsplit(vim.fn.fnameescape(path))
      end),
      path_action('/tmp/vifm-cd', function(path)
        cwd.set(path)
      end),
      path_action('/tmp/vifm-grep', function(path)
        telescope_builtin.live_grep({
          prompt_title = 'Live Grep in ' .. path,
          search_dirs = { path },
        })
      end),
    },
    winhl = 'Normal',
    height = 0.95,
    width = 0.95,
  })
end)
