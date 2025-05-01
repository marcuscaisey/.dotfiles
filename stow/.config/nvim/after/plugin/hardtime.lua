local ok, hardtime = pcall(require, 'hardtime')
if not ok then
  return
end

hardtime.setup({
  disabled_filetypes = { 'qf', 'mason', 'oil', 'packer', 'help' },
  disabled_keys = {
    ['<Up>'] = {},
    ['<Down>'] = {},
  },
})
