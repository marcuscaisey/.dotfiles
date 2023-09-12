local group = vim.api.nvim_create_augroup('misc', { clear = true })

vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local last_line = vim.fn.line([['"]])
    local lines = vim.fn.line('$')
    if last_line ~= 0 and last_line <= lines then
      local last_col = vim.fn.col([['"]])
      vim.api.nvim_win_set_cursor(0, { last_line, last_col })
    end
  end,
  group = group,
  desc = 'Jump to last file position',
})

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function()
    local file_extension = vim.fn.expand('%:e')
    if file_extension ~= 'diff' then
      vim.cmd('%s/\\s\\+$//e')
    end
  end,
  group = group,
  desc = 'Trim trailing whitespace',
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 1000 })
  end,
  group = group,
  desc = 'Highlight yanked text',
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  pattern = '*',
  callback = function()
    if vim.fn.mode() ~= 'i' and vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
  group = group,
  desc = 'Set relativenumber in focused window when not in insert mode',
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  pattern = '*',
  callback = function()
    vim.wo.relativenumber = false
  end,
  group = group,
  desc = 'Unset relativenumber in unfocused windows or when in insert mode',
})

vim.api.nvim_create_autocmd({ 'VimLeave' }, {
  callback = function()
    if os.getenv('TMUX') then
      vim.system({ 'tmux', 'set-window-option', 'automatic-rename', 'on' })
    end
  end,
  group = group,
  desc = 'Turn tmux automatic window renaming on',
})

vim.api.nvim_create_autocmd({ 'DirChanged' }, {
  callback = function()
    if os.getenv('TMUX') then
      vim.system({ 'tmux', 'rename-window', vim.fs.basename(vim.v.event.cwd) .. ':nvim' })
    end
  end,
  group = group,
  desc = 'Rename the tmux window to $cwd:nvim',
})

local diff_augroup = vim.api.nvim_create_augroup('diff', { clear = true })
vim.api.nvim_create_autocmd('VimEnter', {
  group = diff_augroup,
  desc = 'Disable diagnostics in all windows with diff enabled',
  callback = function()
    for _, winid in ipairs(vim.api.nvim_list_wins()) do
      if vim.wo[winid].diff then
        vim.diagnostic.disable(vim.api.nvim_win_get_buf(winid))
      end
    end
  end,
})
vim.api.nvim_create_autocmd('OptionSet', {
  group = diff_augroup,
  pattern = 'diff',
  desc = 'Toggle diagnostics when diff enabled and disabled',
  callback = function()
    if vim.v.option_new == '1' then
      vim.diagnostic.disable(0)
    else
      vim.diagnostic.enable(0)
    end
  end,
})
