-- stylua: ignore start
vim.keymap.set('n', '<leader>dt', '<cmd>diffthis<cr>', { desc = ':diffthis', silent = true })
vim.keymap.set('n', '<leader>do', '<cmd>diffoff!<cr>', { desc = ':diffoff!', silent = true })
vim.keymap.set({'n', 'x'}, ']n', function()
  vim.fn.search([[^\(<\{7}\||\{7}\|=\{7}\|>\{7}\)]], 'W')
end, { desc = 'Jump to next git conflict marker (<<<<<<<, |||||||, =======, >>>>>>>)' })
vim.keymap.set({'n', 'x'}, '[n', function()
  vim.fn.search([[^\(<\{7}\||\{7}\|=\{7}\|>\{7}\)]], 'bW')
end, { desc = 'Jump to previous git conflict marker (<<<<<<<, |||||||, =======, >>>>>>>)' })
-- stylua: ignore end

local augroup = vim.api.nvim_create_augroup('diff', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup,
  desc = 'Disable diagnostics in all windows with diff enabled',
  callback = function()
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
      if vim.wo[winid].diff then
        vim.diagnostic.enable(false, { bufnr = vim.api.nvim_win_get_buf(winid) })
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
      vim.diagnostic.enable(false, { bufnr = 0 })
    else
      vim.diagnostic.enable(true, { bufnr = 0 })
    end
  end,
})
