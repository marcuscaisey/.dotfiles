local ok, undotree = pcall(require, 'undotree')
if not ok then
  return
end

vim.keymap.set('n', '<Leader>u', function()
  undotree.open({ command = '45vnew' })
end, { desc = [[undotree.open({ command = '45vnew' })]] })
