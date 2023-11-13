vim.opt_local.textwidth = 120
vim.opt_local.expandtab = false

if vim.g.loaded_go then
  return
end
vim.g.loaded_go = true

vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('go', { clear = true }),
  pattern = { '*.go' },
  desc = 'Run puku on parent directory',
  callback = function(args)
    if #vim.fs.find('.plzconfig', { upward = true, path = args.file }) < 1 then
      return
    end
    local r = vim.system({ 'puku', 'fmt', '...' }, { cwd = vim.fs.dirname(args.file) }):wait()
    if r.code == 0 then
      print(r.stdout)
    else
      print(r.stderr)
    end
  end,
})
