vim.g.oscyank_silent = true

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
      vim.cmd 'OSCYankReg "'
    end
  end,
  group = vim.api.nvim_create_augroup('oscyank', { clear = true }),
})
