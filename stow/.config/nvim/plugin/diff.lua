vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('diff.disable_diagnostics', {}),
    desc = 'Disable diagnostics in all windows with diff enabled',
    callback = function()
        for _, winid in ipairs(vim.api.nvim_list_wins()) do
            if vim.wo[winid].diff then
                vim.diagnostic.enable(false, { bufnr = vim.api.nvim_win_get_buf(winid) })
            end
        end
    end,
})
vim.api.nvim_create_autocmd('OptionSet', {
    group = vim.api.nvim_create_augroup('diff.toggle_diagnostics', {}),
    pattern = 'diff',
    desc = 'Toggle diagnostics when diff enabled and disabled',
    command = "lua vim.diagnostic.enable(vim.v.option_new ~= '1', { bufnr = 0 })",
})

vim.keymap.set('n', 'yod', '<Cmd>execute &diff ? "diffoff" : "diffthis"<CR>')
vim.keymap.set('n', 'yoD', '<Cmd>diffoff!<CR>')
