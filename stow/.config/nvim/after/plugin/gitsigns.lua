local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then
  return
end

gitsigns.setup({
  numhl = true,
  attach_to_untracked = true,
  ---@param status {added:integer, changed:integer, removed:integer}
  ---@return string
  status_formatter = function(status)
    local added, changed, removed = status.added, status.changed, status.removed
    local status_txt = {}
    if added and added > 0 then
      table.insert(status_txt, '%#GitSignsAdd#+' .. added)
    end
    if changed and changed > 0 then
      table.insert(status_txt, '%#GitSignsChange#~' .. changed)
    end
    if removed and removed > 0 then
      table.insert(status_txt, '%#GitSignsDelete#-' .. removed)
    end
    return table.concat(status_txt, ' ')
  end,
})

vim.keymap.set('n', ']c', '<Cmd>execute &diff ? "normal! ]c" : "Gitsigns nav_hunk next"<CR>')
vim.keymap.set('n', '[c', '<Cmd>execute &diff ? "normal! [c" : "Gitsigns nav_hunk prev"<CR>')
vim.keymap.set('n', '<Leader>hs', '<Cmd>Gitsigns stage_hunk<CR>')
vim.keymap.set('v', '<Leader>hs', "<Cmd>lua require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })<CR>")
vim.keymap.set('n', '<Leader>hS', '<Cmd>Gitsigns stage_buffer<CR>')
vim.keymap.set('n', '<Leader>hr', '<Cmd>Gitsigns reset_hunk<CR>')
vim.keymap.set('v', '<Leader>hr', "<Cmd>lua require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })<CR>")
vim.keymap.set('n', '<Leader>hR', '<Cmd>Gitsigns reset_buffer<CR>')
vim.keymap.set('n', '<Leader>hp', '<Cmd>Gitsigns preview_hunk_inline<CR>')
vim.keymap.set('n', '<Leader>gc', function()
  ---@diagnostic disable-next-line: redundant-parameter
  gitsigns.setqflist('all', { open = false }, function()
    local qflist = vim.fn.getqflist()
    if #qflist == 0 then
      vim.notify('No Git changes', vim.log.levels.INFO)
      vim.cmd.cclose()
      return
    end
    vim.cmd.copen()
    vim.cmd.cfirst()
  end)
end, { desc = 'gitsigns.setqflist()' })
