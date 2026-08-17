vim.bo.expandtab = false
vim.bo.textwidth = 100
if vim.startswith(vim.api.nvim_buf_get_name(0), '/opt/homebrew/Cellar/go') then
    vim.b.editorconfig = false
end
