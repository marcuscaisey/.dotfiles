vim.opt_local.textwidth = 120
vim.opt_local.expandtab = false

if vim.g.loaded_go then
  return
end
vim.g.loaded_go = true

vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('go', { clear = true }),
  pattern = { '*.go' },
  desc = 'Run wollemi on parent directory',
  callback = function(args)
    if #vim.fs.find('.plzconfig', { upward = true, path = args.file }) < 1 then
      return
    end
    local output_lines = {}
    local function on_output(_, line)
      table.insert(output_lines, line)
    end
    local function on_exit()
      vim.print(table.concat(output_lines, '\n'))
    end
    vim.system({ 'wollemi', 'gofmt' }, {
      -- Run in the directory of the saved file since wollemi won't run outside of a plz repo
      cwd = vim.fs.dirname(args.file),
      env = {
        -- wollemi needs GOROOT to be set
        GOROOT = vim.trim(vim.system({ 'go', 'env', 'GOROOT' }):wait().stdout),
        PATH = os.getenv('PATH') or '',
      },
      stdout = on_output,
      stderr = on_output,
    }, on_exit)
  end,
})
