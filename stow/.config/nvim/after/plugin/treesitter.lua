local ok, treesitter = pcall(require, 'nvim-treesitter')
if not ok then
  return
end

vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('nvim-treesitter_lox_setup', {}),
  pattern = 'TSUpdate',
  desc = 'Add lox to treesitter parsers',
  callback = function()
    local parsers = require('nvim-treesitter.parsers')
    parsers.lox = {
      ---@diagnostic disable-next-line: missing-fields
      install_info = {
        branch = 'master',
        location = 'tree-sitter-lox',
        path = '~/scratch/lox',
        queries = 'tree-sitter-lox/queries/lox',
      },
      tier = 3,
    }
  end,
})

treesitter.install({ 'stable', 'unstable', 'lox' })
