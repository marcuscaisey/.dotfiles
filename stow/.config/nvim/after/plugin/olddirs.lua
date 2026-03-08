local ok, olddirs = pcall(require, 'olddirs')
if not ok then
    return
end

---@diagnostic disable-next-line: missing-fields
olddirs.setup({
    limit = 500,
})
