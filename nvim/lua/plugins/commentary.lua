local group = vim.api.nvim_create_augroup('commentary', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.bo.commentstring = '--%s'
  end,
  pattern = { 'sql' },
  group = group,
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.bo.commentstring = '#%s'
  end,
  pattern = { 'toml', 'please' },
  group = group,
})
