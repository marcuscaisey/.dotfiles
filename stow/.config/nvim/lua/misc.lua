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

vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    -- winbufnr == -1 when the buffer doesn't exist, i.e. there's no second buffer and we're in the last buffer of the
    -- window
    if vim.bo.buftype == 'quickfix' and vim.fn.winbufnr(2) == -1 then
      vim.cmd.quit()
    end
  end,
  group = group,
  desc = 'Quit vim if quickfix is last open buffer',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function()
    vim.wo.wrap = false
  end,
  group = group,
  desc = 'Turn off wrapping in quickfix',
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

vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function()
    local filepath = vim.api.nvim_buf_get_name(0)
    local plz_root = vim.fs.find('.plzconfig', { upward = true, path = filepath })[1]
    if not plz_root then
      return
    end
    local output_lines = {}
    local on_output = function(_, line)
      table.insert(output_lines, line)
    end
    local on_exit = function()
      vim.print(table.concat(output_lines, '\n'))
    end
    vim.system({ 'wollemi', 'gofmt' }, {
      -- Run in the directory of the saved file since wollemi won't run outside of a plz repo
      cwd = vim.fs.dirname(filepath),
      env = {
        -- wollemi needs GOROOT to be set
        GOROOT = vim.trim(vim.system({ 'go', 'env', 'GOROOT' }):wait().stdout),
        PATH = vim.fn.getenv('PATH'),
      },
      stdout = on_output,
      stderr = on_output,
    }, on_exit)
  end,
  pattern = { '*.go' },
  group = group,
  desc = 'Run wollemi on parent directory of go file',
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
