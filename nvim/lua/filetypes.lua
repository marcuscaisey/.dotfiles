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
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
  pattern = { 'lua', 'javascript', 'json', 'jsonc' },
  group = group,
  desc = 'Use 2 space tabs',
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.bo.textwidth = 100
  end,
  pattern = { 'python' },
  group = group,
  desc = 'Use 100 textwidth',
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.bo.textwidth = 120
  end,
  pattern = { 'go', 'lua' },
  group = group,
  desc = 'Use 120 textwidth',
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.bo.expandtab = false
  end,
  pattern = { 'go' },
  group = group,
  desc = 'Indent with tabs',
})
