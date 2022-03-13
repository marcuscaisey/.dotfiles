local group = vim.api.nvim_create_augroup('misc', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
  command = [[ if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]],
  group = group,
  desc = 'Jump to last position when opening a file',
})

vim.api.nvim_create_autocmd('BufWritePre', {
  command = [[ if expand('%:e') !=# 'diff' | %s/\s\+$//e | endif ]],
  group = group,
  desc = 'Trim trailing whitespace on write',
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 1000 }
  end,
  group = group,
  desc = 'Highlight yanked text',
})

vim.api.nvim_create_autocmd('BufWritePost', {
  command = [[ silent execute '!wollemi --log fatal gofmt' fnamemodify(expand('%:h'), ':.') ]],
  pattern = { '*.go' },
  group = group,
  desc = 'Run wollemi on parent directory of go files on save',
})
