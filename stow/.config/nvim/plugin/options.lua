vim.o.clipboard = 'unnamed'
vim.o.colorcolumn = '+1'
vim.o.completeopt = 'menuone,popup,noinsert,fuzzy'
vim.o.cursorline = true
vim.opt.diffopt:append('linematch:60')
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.laststatus = 3
vim.o.number = true
vim.o.pumheight = 10
vim.o.relativenumber = true
vim.o.scrolloff = 10
vim.o.shada = "!,'500,<50,s10,h"
vim.o.shiftwidth = 4
vim.o.signcolumn = 'yes:2'
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.updatetime = 100

require('vim._extui').enable({})

vim.filetype.add({
  extension = {
    lox = 'lox',
    vifm = 'vim',
  },
  filename = {
    vifmrc = 'vim',
    ['new-commit'] = 'gitcommit',
  },
})

local augroup = vim.api.nvim_create_augroup('options', { clear = true })

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
