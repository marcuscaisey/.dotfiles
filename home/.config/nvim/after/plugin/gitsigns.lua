local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then
    return
end

gitsigns.setup({ attach_to_untracked = true })

vim.keymap.set('n', ']c', '<Cmd>execute &diff ? "normal! ]c" : "Gitsigns nav_hunk next"<CR>')
vim.keymap.set('n', '[c', '<Cmd>execute &diff ? "normal! [c" : "Gitsigns nav_hunk prev"<CR>')
vim.keymap.set('n', ']C', '<Cmd>Gitsigns nav_hunk next --target=all<CR>')
vim.keymap.set('n', '[C', '<Cmd>Gitsigns nav_hunk prev --target=all<CR>')
vim.keymap.set({ 'n', 'v' }, '<Leader>hs', ':Gitsigns stage_hunk<CR>', { silent = true })
vim.keymap.set('n', '<Leader>hS', '<Cmd>Gitsigns stage_buffer<CR>')
vim.keymap.set({ 'n', 'v' }, '<Leader>hr', ':Gitsigns reset_hunk<CR>', { silent = true })
vim.keymap.set('n', '<Leader>hR', '<Cmd>Gitsigns reset_buffer<CR>')
vim.keymap.set('n', '<Leader>hp', '<Cmd>Gitsigns preview_hunk_inline<CR>')
vim.keymap.set('n', '<Leader>gc', function()
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
end, { desc = 'Send git changes to quickfix' })
