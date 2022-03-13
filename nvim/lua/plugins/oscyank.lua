vim.g.oscyank_silent = true

vim.api.nvim_create_autocmd('TextYankPost', {
  command = [[ if v:event.operator is 'y' && v:event.regname is '' | execute 'OSCYankReg "' | endif ]],
  group = vim.api.nvim_create_augroup('oscyank', { clear = true }),
})
