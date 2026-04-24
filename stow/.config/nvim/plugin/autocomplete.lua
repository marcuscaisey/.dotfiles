vim.api.nvim_create_autocmd('InsertCharPre', {
    desc = 'Enable autocomplete and trigger completion if a non-space character is typed',
    group = vim.api.nvim_create_augroup('autocomplete.enable_autocomplete', {}),
    callback = function()
        if not vim.o.autocomplete and vim.v.char ~= ' ' then
            vim.o.autocomplete = true
            local key = vim.api.nvim_replace_termcodes('<C-n>', true, false, true)
            vim.api.nvim_feedkeys(key, 'n', false)
        end
    end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
    desc = 'Disable autocomplete',
    group = vim.api.nvim_create_augroup('autocomplete.disable_autocomplete', {}),
    command = 'set noautocomplete',
})

vim.api.nvim_create_autocmd('CmdlineChanged', {
    desc = 'Trigger command line completion',
    group = vim.api.nvim_create_augroup('autocomplete.trigger_cmdline_autocomplete', {}),
    pattern = { ':', '/', '?' },
    command = 'call wildtrigger()',
})
