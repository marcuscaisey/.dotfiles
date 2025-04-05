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
    vim.cmd.normal({ ']c', bang = true })
  end
  actions.nav_hunk('next', { greedy = false })
end, { desc = 'gitsigns.actions.nav_hunk("next")' })
vim.keymap.set('n', '[c', function()
  if vim.wo.diff then
    vim.cmd.normal({ ']c', bang = true })
  end
  actions.nav_hunk('prev', { greedy = false })
end, { desc = 'gitsigns.actions.nav_hunk("prev")' })
vim.keymap.set('n', '<Leader>hs', function()
  actions.stage_hunk(nil, { greedy = false })
end, { desc = 'gitsigns.actions.stage_hunk()' })
vim.keymap.set('v', '<Leader>hs', function()
  actions.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end, { desc = 'gitsigns.actions.stage_hunk()' })
vim.keymap.set('n', '<Leader>hS', actions.stage_buffer, { desc = 'gitsigns.actions.stage_buffer()' })
vim.keymap.set('n', '<Leader>hr', function()
  actions.reset_hunk(nil, { greedy = false })
end, { desc = 'gitsigns.actions.reset_hunk()' })
vim.keymap.set('v', '<Leader>hr', function()
  actions.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end, { desc = 'gitsigns.actions.reset_hunk()' })
vim.keymap.set('n', '<Leader>hR', actions.reset_buffer, { desc = 'gitsigns.actions.reset_buffer()' })
vim.keymap.set('n', '<Leader>hp', actions.preview_hunk, { desc = 'gitsigns.actions.preview_hunk()' })
vim.keymap.set('n', '<Leader>gc', function()
  ---@diagnostic disable-next-line: redundant-parameter
  gitsigns.setqflist('all', { open = false }, function()
    local qflist = vim.fn.getqflist()
    if #qflist == 0 then
      vim.notify('No Git changes', vim.log.levels.INFO)
      vim.cmd.cclose()
      return
    end
    -- Remove duplicate hunks
    for i = #qflist, 2, -1 do
      local bufnr = qflist[i].bufnr
      local prev_bufnr = qflist[i - 1].bufnr
      local hunk_range = qflist[i].text:match('Lines %d+-%d+')
      local prev_hunk_range = qflist[i - 1].text:match('Lines %d+-%d+')
      if bufnr == prev_bufnr and hunk_range == prev_hunk_range then
        table.remove(qflist, i)
      end
    end
    vim.fn.setqflist(qflist)
    vim.cmd.copen()
    vim.cmd.cfirst()
  end)
end, { desc = 'gitsigns.setqflist()' })
