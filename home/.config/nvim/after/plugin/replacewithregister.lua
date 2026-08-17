vim.keymap.set('n', '<Leader>r', '<Plug>ReplaceWithRegisterOperator', { desc = 'Replace {motion} text with the contents of register x' })
vim.keymap.set('n', '<Leader>rr', '<Plug>ReplaceWithRegisterLine', { desc = 'Replace [count] lines with the contents of register x' })
vim.keymap.set('v', '<Leader>r', '<Plug>ReplaceWithRegisterVisual', { desc = 'Replace the selection with the contents of register x' })

-- Unset so that the plugin will be loaded when we call :packadd.
vim.g.loaded_ReplaceWithRegister = nil
vim.cmd.packadd('vim-ReplaceWithRegister')
