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
    greedy = true,
  })
end)
vim.keymap.set('n', '[c', function()
  gitsigns.prev_hunk({
    navigation_message = true,
    greedy = true,
  })
end)
vim.keymap.set({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer)
vim.keymap.set('n', '<leader>hu', gitsigns.undo_stage_hunk)
vim.keymap.set({ 'n', 'v' }, '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>')
vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer)
vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk_inline)
vim.keymap.set('n', '<leader>hd', gitsigns.toggle_deleted)
vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
vim.keymap.set('n', '<leader>gc', function()
  vim.fn.system('git diff --quiet')
  if vim.v.shell_error == 0 then
    print('No Git changes')
    vim.cmd.cclose()
    return
  end

  vim.fn.setqflist({})
  gitsigns.setqflist('all', { open = false })
  -- wait for quickfix list to have items in before opening
  vim.wait(5000, function()
    local qf_items = vim.fn.getqflist()
    return #qf_items > 0
  end, 10)
  vim.cmd.copen()
  vim.cmd.cfirst()
end)
