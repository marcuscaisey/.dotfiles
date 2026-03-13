local ok, fzf = pcall(require, 'fzf-lua')
if not ok then
    return
end

fzf.setup({
    defaults = {
        copen = function()
            if vim.bo.filetype == 'oil' then
                local oil = require('oil')
                oil.close()
            end
            vim.cmd.copen()
            vim.cmd.cfirst()
        end,
        lopen = function()
            if vim.bo.filetype == 'oil' then
                local oil = require('oil')
                oil.close()
            end
            vim.cmd.lopen()
            vim.cmd.lfirst()
        end,
        fzf_opts = { ['--cycle'] = true },
    },
    keymap = {
        fzf = {
            true,
            ['ctrl-q'] = 'select-all+accept',
            ['ctrl-l'] = 'select-all+print(_file_sel_to_ll)+accept',
        },
    },
    actions = {
        files = {
            true,
            -- Default alt-f mapping clobbers the one provided by fzf to jump to the next word.
            ['alt-f'] = false,
            ['_file_sel_to_ll'] = fzf.actions.file_sel_to_ll,
        },
    },
    winopts = {
        width = 0.9,
        height = 0.9,
        ---@diagnostic disable-next-line: missing-fields
        preview = { horizontal = 'right:50%' },
    },
    files = { fd_opts = '--follow --strip-cwd-prefix ' .. fzf.defaults.files.fd_opts },
    grep = { rg_opts = '--hidden --follow --glob=!.git ' .. fzf.defaults.grep.rg_opts },
    lsp = {
        jump1 = false, -- Show the UI when result is a single entry.
        symbols = {
            symbol_style = 3, -- Omit kind icon
            symbol_hl = function(s)
                return 'LspItemKind' .. s
            end,
            -- Default format surrounds symbol in []
            symbol_fmt = function(s)
                return s
            end,
        },
        document_symbols = {
            -- Omit line and column
            fzf_opts = vim.tbl_extend('force', fzf.defaults.lsp.document_symbols.fzf_opts, {
                ['--delimiter'] = '\\t\\t',
                ['--with-nth'] = '2..',
            }),
        },
    },
    oldfiles = {
        cwd_only = true,
        actions = {
            ['alt-c'] = {
                fn = function(_, opts)
                    fzf.actions.toggle_opt(opts, 'cwd_only')
                end,
                desc = 'toggle-cwd-only',
                reuse = true,
            },
        },
    },
    olddirs = { git_repo_only = true },
    ui_select = true,
})

vim.keymap.set('n', '<C-P>', '<Cmd>FzfLua files<CR>', { desc = 'Find files' })
vim.keymap.set('n', '<C-\\>', '<Cmd>FzfLua buffers<CR>', { desc = 'List buffers' })
vim.keymap.set('n', '<C-G>', '<Cmd>FzfLua live_grep<CR>', { desc = 'Live grep' })
vim.keymap.set('n', '<C-_>', '<Cmd>FzfLua grep_curbuf<CR>', { desc = 'Grep over current buffer' })
vim.keymap.set('n', '<F1>', '<Cmd>FzfLua help_tags<CR>', { desc = 'Search through help tags' })
vim.keymap.set('n', '<C-K>', '<Cmd>FzfLua oldfiles<CR>', { desc = 'List oldfiles' })
vim.keymap.set('n', '<C-J>', '<Cmd>lua require("olddirs").fzf_picker()<CR>', { desc = 'List olddirs' })
vim.keymap.set('n', '<Leader>zz', '<Cmd>FzfLua builtin<CR>', { desc = 'List builtin fzf pickers' })
vim.keymap.set('n', '<Leader>zr', '<Cmd>FzfLua resume<CR>', { desc = 'Resume previous fzf picker' })
vim.keymap.set('n', 'gO', '<Cmd>FzfLua lsp_document_symbols<CR>', { desc = 'List document symbols' })
vim.keymap.set('n', 'gwO', '<Cmd>FzfLua lsp_live_workspace_symbols<CR>', { desc = 'List workspace symbols' })
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('fzf.lsp_definitions_mappings', {}),
    desc = 'Add mappings for FzfLua lsp_definitions if the client supports it',
    ---@param ev vim.api.keyset.create_autocmd.callback_args
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method('textDocument/definition') then
            vim.keymap.set('n', 'g]', '<Cmd>FzfLua lsp_definitions<CR>', { buffer = 0, desc = 'Jump to definition (always show UI)' })
            vim.keymap.set('n', 'g<C-]>', '<Cmd>FzfLua lsp_definitions jump1<CR>', { buffer = 0, desc = 'Jump to definition (show UI if multiple)' })
        end
    end,
})
vim.keymap.set('n', 'grr', '<Cmd>FzfLua lsp_references<CR>', { desc = 'List references' })
vim.keymap.set('n', 'gri', '<Cmd>FzfLua lsp_implementations<CR>', { desc = 'List implementations' })
