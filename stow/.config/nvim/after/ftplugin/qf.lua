vim.opt_local.wrap = false

if vim.g.loaded_qf then
  return
end
vim.g.loaded_qf = true

vim.api.nvim_create_autocmd('WinClosed', {
  callback = function(args)
    local closed_winid = tonumber(args.match)
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
      if winid ~= closed_winid then
        local bufnr = vim.api.nvim_win_get_buf(winid)
        if vim.bo[bufnr].filetype ~= 'qf' then
          return
        end
      end
    end
    vim.cmd.quitall()
  end,
  group = vim.api.nvim_create_augroup('qf', { clear = true }),
  desc = 'Quit if last open window is the quickfix',
})
