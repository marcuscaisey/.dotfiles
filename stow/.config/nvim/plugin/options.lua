require('vim._extui').enable({})
local extui_enabled = true
vim.keymap.set('n', 'you', function()
  extui_enabled = not extui_enabled
  require('vim._extui').enable({ enable = extui_enabled })
  print((extui_enabled and 'Enabled' or 'Disabled') .. ' extui')
end, { desc = 'Toggle extui' })

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

vim.keymap.set('n', 'yow', function()
  vim.wo.wrap = not vim.wo.wrap
  print((vim.wo.wrap and 'Enabled' or 'Disabled') .. ' line wrapping')
end, { desc = 'Toggle line wrapping in the current window' })
