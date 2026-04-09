vim.api.nvim_create_autocmd('BufWinEnter', {
    desc = 'Jump to last file position',
    group = vim.api.nvim_create_augroup('buffer.jump_to_last_position', {}),
    callback = function(ev)
        local pos = vim.api.nvim_buf_get_mark(ev.buf, '"')
        if pos[1] >= 1 and pos[1] <= vim.fn.line('$') and not vim.tbl_contains({ 'gitcommit', 'gitrebase' }, vim.o.filetype) then
            vim.api.nvim_win_set_cursor(0, pos)
        end
    end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'Trim trailing whitespace',
    group = vim.api.nvim_create_augroup('buffer.trim_trailing_whitespace', {}),
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd('silent! undojoin')
        vim.cmd('silent keepjumps keeppatterns %s/\\s\\+$//e')
        vim.fn.winrestview(view)
    end,
})
