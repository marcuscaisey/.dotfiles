vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'Disable diagnostics in all windows with diff enabled',
    group = vim.api.nvim_create_augroup('diff.disable_diagnostics', {}),
    callback = function()
        for _, winid in ipairs(vim.api.nvim_list_wins()) do
            if vim.wo[winid].diff then
                vim.diagnostic.enable(false, { bufnr = vim.api.nvim_win_get_buf(winid) })
            end
        end
    end,
})
vim.api.nvim_create_autocmd('OptionSet', {
    desc = 'Toggle diagnostics when diff enabled and disabled',
    group = vim.api.nvim_create_augroup('diff.toggle_diagnostics', {}),
    pattern = 'diff',
    command = "lua vim.diagnostic.enable(vim.v.option_new ~= '1', { bufnr = 0 })",
})

vim.keymap.set('n', 'yod', '<Cmd>execute &diff ? "diffoff" : "diffthis"<CR>', { desc = 'Toggle diff in window' })
vim.keymap.set('n', 'yoD', '<Cmd>diffoff!<CR>', { desc = 'Switch off diff in all windows' })
