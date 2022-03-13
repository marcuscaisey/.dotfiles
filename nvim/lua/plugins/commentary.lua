local group = vim.api.nvim_create_augroup('commentary', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  command = 'setlocal commentstring=--%s',
  pattern = { 'sql' },
  group = group,
})

vim.api.nvim_create_autocmd('FileType', {
  command = 'setlocal commentstring=#%s',
  pattern = { 'toml', 'please' },
  group = group,
})
