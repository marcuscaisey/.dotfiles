local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then
  return
end
local actions = require('gitsigns.actions')

gitsigns.setup({
  numhl = true,
  preview_config = {
    border = 'none',
    relative = 'cursor',
  },
  attach_to_untracked = true,
})

vim.keymap.set('n', ']c', function()
  if vim.wo.diff then
    return ']c'
  end
  actions.nav_hunk('next', { navigation_message = true })
  return '<Ignore>'
end, { expr = true, desc = 'gitsigns.actions.nav_hunk("next")' })
vim.keymap.set('n', '[c', function()
  if vim.wo.diff then
    return '[c'
  end
  actions.nav_hunk('prev', { navigation_message = true })
  return '<Ignore>'
end, { expr = true, desc = 'gitsigns.actions.nav_hunk("prev")' })
vim.keymap.set('n', '<Leader>hs', actions.stage_hunk, { desc = 'gitsigns.actions.stage_hunk()' })
vim.keymap.set('v', '<Leader>hs', function()
  actions.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end, { desc = 'gitsigns.actions.stage_hunk()' })
vim.keymap.set('n', '<Leader>hS', actions.stage_buffer, { desc = 'gitsigns.actions.stage_buffer()' })
vim.keymap.set('n', '<Leader>hr', actions.reset_hunk, { desc = 'gitsigns.actions.reset_hunk()' })
vim.keymap.set('v', '<Leader>hr', function()
  actions.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end, { desc = 'gitsigns.actions.reset_hunk()' })
vim.keymap.set('n', '<Leader>hR', actions.reset_buffer, { desc = 'gitsigns.actions.reset_buffer()' })
vim.keymap.set('n', '<Leader>hp', actions.preview_hunk_inline, { desc = 'gitsigns.actions.preview_hunk_inline()' })
vim.keymap.set('n', '<Leader>gc', function()
  gitsigns.setqflist('all', { open = false }, function()
    if #vim.fn.getqflist() == 0 then
      vim.notify('No Git changes', vim.log.levels.INFO)
      vim.cmd.cclose()
      return
    end
    vim.cmd.copen()
    vim.cmd.cfirst()
  end)
end, { desc = 'gitsigns.setqflist()' })
