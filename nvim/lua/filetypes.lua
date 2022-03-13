-- Only use lua filetype detection
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.filetype.add {
  extension = {
    build_defs = 'please',
    plz = 'please',
  },
  filename = {
    ['BUILD'] = 'please',
  },
}

local group = vim.api.nvim_create_augroup('filetypes', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  command = 'setlocal tabstop=2 shiftwidth=2',
  pattern = { 'lua', 'javascript', 'json', 'jsonc' },
  group = group,
  desc = 'Use 2 space tabs for some file types',
})

vim.api.nvim_create_autocmd('FileType', {
  command = 'setlocal textwidth=100 | set formatoptions -=t',
  pattern = { 'python' },
  group = group,
  desc = 'Use 100 textwidth for some file types',
})

vim.api.nvim_create_autocmd('FileType', {
  command = 'setlocal textwidth=120 | set formatoptions -=t',
  pattern = { 'go', 'lua' },
  group = group,
  desc = 'Use 120 textwidth for some file types',
})

vim.api.nvim_create_autocmd('FileType', {
  command = 'setlocal noexpandtab',
  pattern = { 'go' },
  group = group,
  desc = 'Use tabs for some file types',
})
