local ui2 = require('vim._core.ui2')
ui2.enable({
    msg = {
        targets = { progress = 'msg' },
    },
})

vim.filetype.add({
    extension = {
        lox = 'lox',
        vifm = 'vim',
        ebnf = 'ebnf',
        tmpl = 'gotmpl',
    },
    filename = {
        vifmrc = 'vim',
        ['new-commit'] = 'gitcommit',
    },
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
    desc = 'Use relative line numbers in focused window when not in insert mode',
    group = vim.api.nvim_create_augroup('options.set_relativenumber', {}),
    command = "if mode() != 'i' && &number | setlocal relativenumber | endif",
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
    desc = 'Use absolute line numbers in unfocused windows or when in insert mode',
    group = vim.api.nvim_create_augroup('options.unset_relativenumber', {}),
    command = 'if &number | set norelativenumber | endif',
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'Remove t, c, r, and o from formatoptions after any ftplugin may have modified them',
    group = vim.api.nvim_create_augroup('options.remove_formatoptions', {}),
    callback = function()
        vim.cmd('setlocal formatoptions-=t')
        vim.cmd('setlocal formatoptions-=c')
        vim.cmd('setlocal formatoptions-=r')
        vim.cmd('setlocal formatoptions-=o')
    end,
})

vim.keymap.set('n', 'yow', '<Cmd>setlocal wrap!<CR>', { desc = 'Toggle line wrapping' })
