vim.keymap.set('n', '<Leader>r', '<Plug>ReplaceWithRegisterOperator')
vim.keymap.set('n', '<Leader>rr', '<Plug>ReplaceWithRegisterLine')
vim.keymap.set('v', '<Leader>r', '<Plug>ReplaceWithRegisterVisual')

-- Unset so that the plugin will be loaded when we call :packadd.
vim.g.loaded_ReplaceWithRegister = nil
vim.cmd.packadd('vim-ReplaceWithRegister')
