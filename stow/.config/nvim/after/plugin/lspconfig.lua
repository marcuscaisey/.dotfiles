vim.api.nvim_create_user_command('LspLog', 'execute "tabnew " . luaeval("vim.lsp.log.get_filename()")', {})
