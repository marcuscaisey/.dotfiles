-- stylua: ignore start
vim.keymap.set('n', '<leader>dt', '<cmd>diffthis<cr>', { desc = 'Make the current window part of the diff windows', silent = true })
vim.keymap.set('n', '<leader>do', '<cmd>diffoff!<cr>', { desc = 'Switch off diff mode for all windows in the current tab page', silent = true })
vim.keymap.set('n', 'dlo', '<cmd>diffget LOCAL<cr>', { desc = 'Modify the current buffer to undo difference with the LOCAL vimdiff buffer', silent = true })
vim.keymap.set('n', 'dro', '<cmd>diffget REMOTE<cr>', { desc = 'Modify the current buffer to undo difference with the REMOTE vimdiff buffer', silent = true })
-- stylua: ignore end

local augroup = vim.api.nvim_create_augroup('diff', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup,
  desc = 'Disable diagnostics in all windows with diff enabled',
  callback = function()
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
      if vim.wo[winid].diff then
        vim.diagnostic.disable(vim.api.nvim_win_get_buf(winid))
      end
    end
  end,
})
vim.api.nvim_create_autocmd('OptionSet', {
  group = augroup,
  pattern = 'diff',
  desc = 'Toggle diagnostics when diff enabled and disabled',
  callback = function()
    if vim.v.option_new == '1' then
      vim.diagnostic.disable(0)
    else
      vim.diagnostic.enable(0)
    end
  end,
})
