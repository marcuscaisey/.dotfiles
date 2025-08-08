vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('puku_format', {}),
  pattern = { '*.go' },
  desc = 'Run puku on saved file',
  callback = function(args)
    if not vim.fs.root(args.match, '.plzconfig') then
      return
    end
    vim.system({ 'puku', 'fmt', args.match }, nil, function(res)
      local output = res.code == 0 and vim.trim(res.stdout) or vim.trim(res.stderr)
      if output ~= '' then
        vim.schedule(function()
          vim.notify('puku: ' .. output, vim.log.levels.INFO)
        end)
      end
    end)
  end,
})
