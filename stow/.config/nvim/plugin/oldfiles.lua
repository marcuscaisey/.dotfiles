vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufNewFile' }, {
    group = vim.api.nvim_create_augroup('oldfiles.add', {}),
    desc = 'Add file to v:oldfiles',
    callback = function(ev)
        if vim.fn.filereadable(ev.file) == 1 or ev.event == 'BufNewFile' then
            local rest = vim.tbl_filter(function(f)
                return f ~= ev.file
            end, vim.v.oldfiles)
            vim.v.oldfiles = { ev.file, unpack(rest) }
        end
    end,
})
