vim.keymap.set('n', 'gq', function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_create_autocmd('CursorMoved', {
        group = vim.api.nvim_create_augroup('formatting.restore_cursor', {}),
        buf = 0,
        once = true,
        desc = 'Restore cursor position after formatting',
        callback = function()
            vim.api.nvim_win_set_cursor(0, cursor)
        end,
    })
    return 'gq'
end, { expr = true, desc = 'gq{motion} formats the lines that {motion} moves over' })
