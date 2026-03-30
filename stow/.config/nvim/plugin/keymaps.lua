vim.keymap.set('n', '<C-W><', '<C-W>5<', { desc = 'Decrease window width by 5' })
vim.keymap.set('n', '<C-W>>', '<C-W>5>', { desc = 'Increase window width by 5' })
vim.keymap.set('n', '<C-W>-', '<C-W>5-', { desc = 'Decrease window height by 5' })
vim.keymap.set('n', '<C-W>+', '<C-W>5+', { desc = 'Increase window height by 5' })

vim.keymap.set('n', 'j', [[(v:count > 1 ? "m'" . v:count : "") . 'j']], { desc = '[count] lines downward linewise', expr = true })
vim.keymap.set('n', 'k', [[(v:count > 1 ? "m'" . v:count : "") . 'k']], { desc = '[count] lines upward linewise', expr = true })

vim.keymap.set('n', '<leader>re', '<Cmd>mksession! /tmp/session.vim | restart +wqa source /tmp/session.vim<CR>', { desc = 'Restart neovim' })

vim.keymap.set('i', '<CR>', 'pumvisible() ? "<C-E><CR>" : "<CR>"', { desc = 'Close popup menu if visible, then <CR>', expr = true })
