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

    -- Merge contiguous hunks
    local contig_hunk_groups = {} ---@type {item:table, from:integer, to:integer}[][]
    for _, item in ipairs(qflist) do
      local from, to = item.text:match('^Lines (%d+)-(%d+).*$')
      from, to = tonumber(from), tonumber(to)
      local hunk = { item = item, from = from, to = to }
      local cur_group = contig_hunk_groups[#contig_hunk_groups]
      local cur_hunk = cur_group and cur_group[#cur_group]
      if cur_hunk and item.bufnr == cur_hunk.item.bufnr and from - cur_hunk.to <= 1 then
        table.insert(cur_group, hunk)
      else
        table.insert(contig_hunk_groups, { hunk })
      end
    end
    local new_qflist = {}
    for _, group in ipairs(contig_hunk_groups) do
      local item = group[1].item
      -- Attempting to stage a group of hunks from the first hunk where the first hunk only spans a single line fails
      -- with "No hunk to stage". Therefore use the second hunk from the group as the quickfix item.
      if #group > 1 and group[1].from == group[1].to then
        item = group[2].item
      end
      item.text = string.format('Lines %s-%s', group[1].from, group[#group].to)
      table.insert(new_qflist, item)
    end

    vim.fn.setqflist(new_qflist)
    vim.cmd.copen()
    vim.cmd.cfirst()
  end)
end, { desc = 'gitsigns.setqflist()' })
