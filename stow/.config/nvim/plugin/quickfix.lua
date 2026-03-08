vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    group = vim.api.nvim_create_augroup('quickfix_sort', {}),
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

vim.keymap.set('n', '<Leader>q', '<Cmd>execute getqflist({"winid": 0}).winid > 0 ? "cclose" : "copen"<CR>')
vim.keymap.set('n', '<Leader>l', '<Cmd>execute getloclist({"winid": 0}).winid > 0 ? "lclose" : "lopen"<CR>')
