local gitsigns = require('gitsigns')

gitsigns.setup({
  numhl = true,
  preview_config = {
    border = 'none',
    relative = 'cursor',
  },
})

vim.keymap.set('n', ']c', function()
  gitsigns.next_hunk({
    navigation_message = true,
    wrap = false,
    greedy = true,
  })
end)
vim.keymap.set('n', '[c', function()
  gitsigns.prev_hunk({
    navigation_message = true,
    wrap = false,
    greedy = true,
  })
end)
vim.keymap.set({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', { silent = true })
vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer)
vim.keymap.set('n', '<leader>hu', gitsigns.undo_stage_hunk)
vim.keymap.set({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<cr>', { silent = true })
vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer)
vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk_inline)
vim.keymap.set('n', '<leader>hd', gitsigns.toggle_deleted)
vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
vim.keymap.set('n', '<leader>gc', function()
  gitsigns.setqflist('all', { open = true })
end)
