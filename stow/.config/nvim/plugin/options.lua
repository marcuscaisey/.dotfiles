vim.opt.clipboard = 'unnamed'
vim.opt.colorcolumn = '+1'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.formatoptions:remove('o')
vim.opt.hidden = true
vim.opt.ignorecase = true
vim.opt.laststatus = 3
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
vim.opt.shiftwidth = 4
vim.opt.signcolumn = 'yes:2'
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.updatetime = 100

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
