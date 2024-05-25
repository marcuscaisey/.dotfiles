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
end, { expr = true })
vim.keymap.set('n', '[c', function()
  if vim.wo.diff then
    return '[c'
  end
  actions.nav_hunk('prev', { navigation_message = true })
  return '<Ignore>'
end, { expr = true })
vim.keymap.set('n', '<leader>hs', actions.stage_hunk)
vim.keymap.set('v', '<leader>hs', function()
  actions.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end)
vim.keymap.set('n', '<leader>hS', actions.stage_buffer)
vim.keymap.set('n', '<leader>hu', actions.undo_stage_hunk)
vim.keymap.set('n', '<leader>hr', actions.reset_hunk)
vim.keymap.set('v', '<leader>hr', function()
  actions.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end)
vim.keymap.set('n', '<leader>hR', actions.reset_buffer)
vim.keymap.set('n', '<leader>hp', actions.preview_hunk_inline)
vim.keymap.set('n', '<leader>gc', function()
  gitsigns.setqflist('all', { open = false }, function()
    if #vim.fn.getqflist() == 0 then
      vim.notfy('No Git changes', vim.log.levels.INFO)
      return
    end
    vim.cmd.copen()
    vim.cmd.cfirst()
  end)
end)
