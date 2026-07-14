vim.keymap.set('n', 'gq', function()
    local view = vim.fn.winsaveview()
    vim.api.nvim_create_autocmd('CursorMoved', {
        group = vim.api.nvim_create_augroup('formatting.restore_cursor'),
        buf = 0,
        once = true,
        desc = 'Restore view after formatting',
        callback = function()
            vim.fn.winrestview(view)
        end,
    })
    return 'gq'
end, { expr = true, desc = 'gq{motion} formats the lines that {motion} moves over' })
