vim.api.nvim_create_autocmd('CmdlineChanged', {
    desc = 'Trigger command line completion',
    group = vim.api.nvim_create_augroup('autocomplete.trigger_cmdline_autocomplete', {}),
    pattern = { ':', '/', '?' },
    command = 'call wildtrigger()',
})
