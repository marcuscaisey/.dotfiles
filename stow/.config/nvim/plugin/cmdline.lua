vim.api.nvim_create_autocmd('CmdlineChanged', {
    desc = 'Trigger wildcard expansion',
    group = vim.api.nvim_create_augroup('cmdline.trigger_wildcard_expansion', {}),
    pattern = { ':', '/', '?' },
    command = 'call wildtrigger()',
})
