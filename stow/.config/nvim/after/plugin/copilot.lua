if vim.fn.exists(':Copilot') ~= 2 then
  return
end
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    vim.cmd.Copilot('setup')
  end,
  once = true,
})
