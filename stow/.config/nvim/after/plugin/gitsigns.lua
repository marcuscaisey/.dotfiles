local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then
  return
end
local actions = require('gitsigns.actions')

gitsigns.setup({
  numhl = true,
  attach_to_untracked = true,
})

vim.keymap.set('n', ']c', function()
  if vim.wo.diff then
    vim.cmd.normal({ ']c', bang = true })
  end
  actions.nav_hunk('next')
end, { desc = 'gitsigns.actions.nav_hunk("next")' })
vim.keymap.set('n', '[c', function()
  if vim.wo.diff then
    vim.cmd.normal({ '[c', bang = true })
  end
  actions.nav_hunk('prev')
end, { desc = 'gitsigns.actions.nav_hunk("prev")' })
vim.keymap.set('n', '<Leader>hs', actions.stage_hunk, { desc = 'gitsigns.actions.stage_hunk()' })
vim.keymap.set('v', '<Leader>hs', function()
  actions.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end, { desc = 'gitsigns.actions.stage_hunk()' })
vim.keymap.set('n', '<Leader>hS', actions.stage_buffer, { desc = 'gitsigns.actions.stage_buffer()' })
vim.keymap.set('n', '<Leader>hr', actions.reset_hunk, { desc = 'gitsigns.actions.revert_hunk()' })
vim.keymap.set('v', '<Leader>hr', function()
  actions.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
end, { desc = 'gitsigns.actions.reset_hunk()' })
vim.keymap.set('n', '<Leader>hR', actions.reset_buffer, { desc = 'gitsigns.actions.reset_buffer()' })
vim.keymap.set('n', '<Leader>hp', actions.preview_hunk_inline, { desc = 'gitsigns.actions.preview_hunk_inline()' })
vim.keymap.set('n', '<Leader>gc', function()
  ---@diagnostic disable-next-line: redundant-parameter
  gitsigns.setqflist('all', { open = false }, function()
    local qflist = vim.fn.getqflist()
    if #qflist == 0 then
      vim.notify('No Git changes', vim.log.levels.INFO)
      vim.cmd.cclose()
      return
    end

    local added_files = vim.trim(vim.system({ 'git', 'ls-files', '--others', '--exclude-standard' }):wait().stdout)
    if added_files ~= '' then
      for filename in vim.gsplit(added_files, '\n') do
        table.insert(qflist, { filename = filename, text = 'Added', lnum = 1, col = 0 })
      end
    end

    vim.fn.setqflist(qflist)
    vim.cmd.copen()
    vim.cmd.cfirst()
  end)
end, { desc = 'gitsigns.setqflist()' })
