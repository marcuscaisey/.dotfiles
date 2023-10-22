vim.keymap.set({ 'i', 's' }, '<c-j>', function()
  vim.snippet.jump(1)
end)
vim.keymap.set({ 'i', 's' }, '<c-k>', function()
  vim.snippet.jump(-1)
end)

vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*:s',
  callback = function()
    if vim.snippet.active() then
      local keys = vim.api.nvim_replace_termcodes('<c-r>_', true, false, true)
      vim.api.nvim_feedkeys(keys, 'n', false)
    end
  end,
  group = vim.api.nvim_create_augroup('snippet', { clear = true }),
  desc = 'Send replaced text to the black hole register',
})
