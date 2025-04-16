local augroup = vim.api.nvim_create_augroup('misc', { clear = true })

vim.api.nvim_create_autocmd('BufWinEnter', {
  callback = function()
    local last_line = vim.fn.line([['"]])
    local lines = vim.fn.line('$')
    if last_line ~= 0 and last_line <= lines then
      local last_col = vim.fn.col([['"]])
      vim.api.nvim_win_set_cursor(0, { last_line, last_col })
    end
  end,
  group = augroup,
  desc = 'Jump to last file position',
})

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    local file_extension = vim.fn.expand('%:e')
    if file_extension ~= 'diff' then
      vim.cmd('%s/\\s\\+$//e')
    end
  end,
  group = augroup,
  desc = 'Trim trailing whitespace',
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 500 })
  end,
  group = augroup,
  desc = 'Highlight yanked text',
})

vim.api.nvim_create_autocmd('InsertEnter', {
  callback = function()
    vim.api.nvim_input('<Cmd>nohlsearch<CR>')
  end,
  group = augroup,
  desc = ':nohlsearch',
})
