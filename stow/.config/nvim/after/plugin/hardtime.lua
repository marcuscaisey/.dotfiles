local ok, hardtime = pcall(require, 'hardtime')
if not ok then
  return
end
hardtime.setup()
