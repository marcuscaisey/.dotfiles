require 'mappings'
require 'options'
require 'filetypes'
require 'colours'
require 'misc'
require 'plugins.packer'

vim.keymap.set('n', '<leader>ff', function()
  local dirs = vim.fn.systemlist 'fd --type directory --strip-cwd-prefix'
  vim.ui.select(dirs, { prompt = 'Find files in:' }, function(selection)
    require('telescope.builtin').find_files { cwd = selection }
    -- hack to make the prompt start in insert mode
    vim.defer_fn(function()
      vim.cmd 'startinsert'
    end, 0)
  end)
end)
