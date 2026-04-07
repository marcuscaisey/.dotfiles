vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    group = vim.api.nvim_create_augroup('quickfix.sort', {}),
    pattern = '*',
    desc = 'Sort quickfix list items',
    callback = function()
        local qflist = vim.fn.getqflist()
        table.sort(qflist, function(a, b)
            local a_name = vim.api.nvim_buf_get_name(a.bufnr)
            local b_name = vim.api.nvim_buf_get_name(b.bufnr)
            if a_name ~= b_name then
                return a_name < b_name
            end
            if a.lnum ~= b.lnum then
                return a.lnum < b.lnum
            end
            return a.col < b.col
        end)
        vim.fn.setqflist(qflist, 'r')
    end,
})

vim.keymap.set('n', '[q', '<Cmd>execute "cprevious" . v:count1<CR>zz', { desc = 'Jump to [count] previous quickfix list entry' })
vim.keymap.set('n', ']q', '<Cmd>execute "cnext " . v:count1<CR>zz', { desc = 'Jump to [count] next quickfix list entry' })
vim.keymap.set('n', '[Q', '<Cmd>cfirst<CR>zz', { desc = 'Jump to first quickfix list entry' })
vim.keymap.set('n', ']Q', '<Cmd>clast<CR>zz', { desc = 'Jump to previous quickfix list entry' })
vim.keymap.set('n', '[<C-Q>', '<Cmd>cpfile<CR>zz', { desc = 'Jump to quickfix list entry in previous file' })
vim.keymap.set('n', ']<C-Q>', '<Cmd>cnfile<CR>zz', { desc = 'Jump to quickfix list entry in next file' })
vim.keymap.set('n', '[l', '<Cmd>execute "lprevious" . v:count1<CR>zz', { desc = 'Jump to [count] previous location list entry' })
vim.keymap.set('n', ']l', '<Cmd>execute "lnext " . v:count1<CR>zz', { desc = 'Jump to [count] next location list entry' })
vim.keymap.set('n', '[L', '<Cmd>lfirst<CR>zz', { desc = 'Jump to first location list entry' })
vim.keymap.set('n', ']L', '<Cmd>llast<CR>zz', { desc = 'Jump to previous location list entry' })
vim.keymap.set('n', '[<C-L>', '<Cmd>lpfile<CR>zz', { desc = 'Jump to location list entry in previous file' })
vim.keymap.set('n', ']<C-L>', '<Cmd>lnfile<CR>zz', { desc = 'Jump to location list entry in next file' })
vim.keymap.set('n', '<Leader>q', '<Cmd>execute getqflist({"winid": 0}).winid > 0 ? "cclose" : "copen"<CR>', { desc = 'Toggle quickfix list' })
vim.keymap.set('n', '<Leader>l', '<Cmd>execute getloclist(0, {"winid": 0}).winid > 0 ? "lclose" : "lopen"<CR>', { desc = 'Toggle location list' })
