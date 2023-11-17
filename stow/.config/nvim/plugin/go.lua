vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('go', { clear = true }),
  pattern = { '*.go' },
  desc = 'Run puku on parent directory',
  callback = function(args)
    if #vim.fs.find('.plzconfig', { upward = true, path = args.file }) < 1 then
      return
    end
    local function output_handler(level)
      return vim.schedule_wrap(function(err, data)
        if err then
          vim.notify(err, vim.log.levels.ERROR)
        elseif data then
          vim.notify(data:gsub('\n$', ''), level)
        end
      end)
    end
    vim.system({ 'puku', 'fmt', '...' }, {
      cwd = vim.fs.dirname(args.file),
      stdout = output_handler(vim.log.levels.INFO),
      stderr = output_handler(vim.log.levels.ERROR),
    })
  end,
})
