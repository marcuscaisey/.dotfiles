local Job = require('plenary.job')
local util = require('lspconfig.util')
local neoformat = require('plugins.neoformat')

local group = vim.api.nvim_create_augroup('misc', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local last_line = vim.fn.line([['"]])
    local lines = vim.fn.line('$')
    if last_line ~= 0 and last_line <= lines then
      local last_col = vim.fn.col([['"]])
      vim.api.nvim_win_set_cursor(0, { last_line, last_col })
    end
  end,
  group = group,
  desc = 'Jump to last file position',
})

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    local file_extension = vim.fn.expand('%:e')
    if file_extension ~= 'diff' then
      vim.cmd('%s/\\s\\+$//e')
    end
  end,
  group = group,
  desc = 'Trim trailing whitespace',
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 1000 })
  end,
  group = group,
  desc = 'Highlight yanked text',
})

vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function()
    local plz_root = util.root_pattern('.plzconfig')(vim.api.nvim_buf_get_name(0))
    if not neoformat.auto_neoformatting_enabled() or not plz_root then
      return
    end
    local output_lines = {}
    local on_output = function(_, line)
      table.insert(output_lines, line)
    end
    local on_exit = function()
      print(table.concat(output_lines, '\n'))
    end
    local job = Job:new({
      command = 'wollemi',
      args = { 'gofmt' },
      -- run in the directory of the saved file since wollemi won't run outside of a plz repo
      cwd = vim.fn.expand('%:p:h'),
      env = {
        -- wollemi needs GOROOT to be set
        GOROOT = vim.trim(vim.fn.system('go env GOROOT')),
        PATH = vim.fn.getenv('PATH'),
      },
      on_stdout = on_output,
      on_stderr = on_output,
      on_exit = on_exit,
    })
    job:start()
  end,
  pattern = { '*.go' },
  group = group,
  desc = 'Run wollemi on parent directory of go files on save',
})

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    -- winbufnr == -1 when the buffer doesn't exist, i.e. there's no second buffer and we're in the last buffer of the
    -- window
    if vim.bo.buftype == 'quickfix' and vim.fn.winbufnr(2) == -1 then
      vim.cmd('quit')
    end
  end,
  group = group,
  desc = 'Quit vim if quickfix is last open buffer',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.wo.wrap = false
  end,
  group = group,
  desc = 'Turn off wrapping in quickfix',
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  pattern = '*',
  callback = function()
    if vim.fn.mode() ~= 'i' and vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
  group = group,
  desc = 'Set relativenumber in focused window when not in insert mode',
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  pattern = '*',
  callback = function()
    vim.wo.relativenumber = false
  end,
  group = group,
  desc = 'Unset relativenumber in unfocused windows or when in insert mode',
})
