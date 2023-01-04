local Job = require('plenary.job')

vim.g.neoformat_enabled_python = { 'black' }
vim.g.neoformat_enabled_lua = { 'stylua' }
vim.g.neoformat_enabled_go = { 'goimports' }
vim.g.neoformat_enabled_sql = { 'sqlformat' }

vim.g.neoformat_sql_sqlformat = {
  exe = 'sqlformat',
  args = { '--reindent', '--keywords', 'upper', '--identifiers', 'lower', '-' },
  stdin = 1,
}

vim.g.neoformat_javascript_prettier = {
  exe = 'prettier',
  args = { '--stdin-filepath', '"%:p"', '--print-width', '100' },
  stdin = 1,
  try_node_exe = 1,
}

local wollemi = function()
  local plz_root = vim.fs.find('.plzconfig', { upward = true })[1]
  if vim.bo.filetype ~= 'go' or not plz_root then
    return
  end
  local output_lines = {}
  local on_output = function(_, line)
    table.insert(output_lines, line)
  end
  local on_exit = function()
    print(table.concat(output_lines, '\n'))
  end
  local job = Job:new({
    command = 'wollemi',
    args = { 'gofmt' },
    -- run in the directory of the saved file since wollemi won't run outside of a plz repo
    cwd = vim.fn.expand('%:p:h'),
    env = {
      -- wollemi needs GOROOT to be set
      GOROOT = vim.trim(vim.fn.system('go env GOROOT')),
      PATH = vim.fn.getenv('PATH'),
    },
    on_stdout = on_output,
    on_stderr = on_output,
    on_exit = on_exit,
  })
  job:start()
end

vim.keymap.set('n', '<leader>fm', function()
  vim.cmd.Neoformat()
  wollemi()
end)
