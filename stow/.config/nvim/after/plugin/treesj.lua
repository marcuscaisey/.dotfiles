local ok, treesj = pcall(require, 'treesj')
if not ok then
  return
end

treesj.setup({
  use_default_keymaps = false,
  max_join_length = 200,
})

vim.keymap.set('n', '<leader>s', treesj.split, { desc = 'treesj.split()' })
vim.keymap.set('n', '<leader>j', treesj.join, { desc = 'treesj.join()' })
