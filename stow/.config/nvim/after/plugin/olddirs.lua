local ok, olddirs = pcall(require, 'olddirs')
if not ok then
  return
end

olddirs.setup({
  limit = 500,
})
