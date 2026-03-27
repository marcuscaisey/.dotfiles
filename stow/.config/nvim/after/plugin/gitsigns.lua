local ok, gitsigns = pcall(require, 'gitsigns')
if not ok then
    return
end

gitsigns.setup({
    numhl = true,
    attach_to_untracked = true,
})

vim.keymap.set('n', ']c', '<Cmd>execute &diff ? "normal! ]c" : "Gitsigns nav_hunk next"<CR>', { desc = 'Jump to next git hunk' })
vim.keymap.set('n', '[c', '<Cmd>execute &diff ? "normal! [c" : "Gitsigns nav_hunk prev"<CR>', { desc = 'Jump to previous git hunk' })
vim.keymap.set({ 'n', 'v' }, '<Leader>hs', ':Gitsigns stage_hunk<CR>', { desc = 'Stage git hunk', silent = true })
vim.keymap.set('n', '<Leader>hS', '<Cmd>Gitsigns stage_buffer<CR>', { desc = 'Stage buffer git hunks' })
vim.keymap.set({ 'n', 'v' }, '<Leader>hr', ':Gitsigns reset_hunk<CR>', { desc = 'Reset git hunk', silent = true })
vim.keymap.set('n', '<Leader>hR', '<Cmd>Gitsigns reset_buffer<CR>', { desc = 'Reset buffer git hunks' })
vim.keymap.set('n', '<Leader>hp', '<Cmd>Gitsigns preview_hunk_inline<CR>', { desc = 'Preview git hunk' })
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
