vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('go', { clear = true }),
  pattern = { '*.go' },
  desc = 'Run puku on parent directory',
  callback = function(args)
    if #vim.fs.find('.plzconfig', { upward = true, path = vim.api.nvim_buf_get_name(args.buf) }) < 1 then
      return
    end
    local function on_event(_, data)
      local msg = table.concat(data, '\n')
      msg = vim.trim(msg)
      msg = msg:gsub('\t', string.rep(' ', 4))
      if msg ~= '' then
        vim.notify('puku: ' .. msg, vim.log.levels.INFO)
      end
    end
    vim.fn.jobstart({ 'puku', 'fmt', '...' }, {
      cwd = vim.fs.dirname(args.file),
      on_stdout = on_event,
      on_stderr = on_event,
      stdout_buffered = true,
      stderr_buffered = true,
    })
  end,
})
