local ui2 = require('vim._core.ui2')
ui2.enable({
  msg = {
    targets = {
      progress = 'msg',
    },
  },
})

vim.filetype.add({
  extension = {
    lox = 'lox',
    vifm = 'vim',
    ebnf = 'ebnf',
    tmpl = 'gotmpl',
  },
  filename = {
    vifmrc = 'vim',
    ['new-commit'] = 'gitcommit',
  },
})

local augroup = vim.api.nvim_create_augroup('options_auto_relativenumber', {})
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  group = augroup,
  desc = 'Set relativenumber in focused window when not in insert mode',
  callback = function()
    if vim.api.nvim_get_mode().mode ~= 'i' and vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  group = augroup,
  desc = 'Unset relativenumber in unfocused windows or when in insert mode',
  callback = function()
    vim.wo.relativenumber = false
  end,
})

vim.keymap.set('n', 'yow', '<Cmd>setlocal wrap!<CR>')
