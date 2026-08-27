local ui2 = require('vim._core.ui2')
ui2.enable({
    msg = {
        targets = { progress = 'msg' },
    },
})

vim.filetype.add({
    extension = {
        alfredappearance = 'json',
        lox = 'lox',
        ebnf = 'ebnf',
        tmpl = function(path)
            local filetype = 'gotmpl'
            local actual_filename = path:gsub('%.tmpl$', '')
            local actual_filetype = vim.filetype.match({ filename = actual_filename })
            if actual_filetype then
                filetype = string.format('%s.%s', actual_filetype, filetype)
            end
            return filetype
        end,
    },
    filename = {
        ['new-commit'] = 'gitcommit',
    },
})

vim.diagnostic.config({
    virtual_text = { source = true },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.INFO] = ' ',
            [vim.diagnostic.severity.HINT] = '󰌵 ',
        },
    },
    float = { source = true },
    severity_sort = true,
})

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.api.nvim_create_autocmd('CmdlineChanged', {
    desc = 'Trigger command line completion',
    group = vim.api.nvim_create_augroup('my.autocomplete.trigger_cmdline_autocomplete'),
    pattern = { ':', '/', '?' },
    command = 'call wildtrigger()',
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    desc = 'Sort quickfix list items',
    group = vim.api.nvim_create_augroup('my.quickfix.sort'),
    callback = function()
        local qflist = vim.fn.getqflist()
        table.sort(qflist, function(a, b)
            local a_name = vim.api.nvim_buf_get_name(a.bufnr)
            local b_name = vim.api.nvim_buf_get_name(b.bufnr)
            if a_name ~= b_name then
                return a_name < b_name
            end
            if a.lnum ~= b.lnum then
                return a.lnum < b.lnum
            end
            return a.col < b.col
        end)
        vim.fn.setqflist(qflist, 'r')
    end,
})

vim.api.nvim_create_autocmd('SessionWritePre', {
    desc = 'Save quickfix state',
    group = vim.api.nvim_create_augroup('my.session.save_quickfix'),
    callback = function()
        local is_open = false
        if vim.fn.getqflist({ winid = 0 }).winid > 0 then
            is_open = true
            vim.cmd.cclose()
        end
        local qflist = vim.fn.getqflist() ---@type vim.quickfix.entry[]
        for _, item in ipairs(qflist) do
            if not item.filename then
                item.filename = vim.api.nvim_buf_get_name(item.bufnr)
            end
            item.bufnr = nil
        end
        ---@type QuickfixState
        local state = {
            items = qflist,
            idx = vim.fn.getqflist({ idx = 0 }).idx,
            is_open = is_open,
        }
        vim.g.QuickfixState = vim.json.encode(state)
    end,
})
vim.api.nvim_create_autocmd('SessionLoadPost', {
    desc = 'Restore quickfix state',
    group = vim.api.nvim_create_augroup('my.session.restore_quickfix'),
    callback = function()
        if not vim.g.QuickfixState then
            return
        end
        ---@class QuickfixState
        ---@field items vim.quickfix.entry[]
        ---@field idx integer
        ---@field is_open boolean
        local state = vim.json.decode(vim.g.QuickfixState) --[[@as QuickfixState]]
        if #state.items > 0 then
            vim.fn.setqflist({}, ' ', { items = state.items, idx = state.idx })
            if state.is_open then
                vim.cmd.copen()
            end
        end
    end,
})

vim.api.nvim_create_autocmd('VimLeave', {
    desc = 'Turn tmux automatic window renaming on',
    group = vim.api.nvim_create_augroup('my.tmux.auto_window_renaming', { clear = true }),
    command = "if !empty($TMUX) | call system(['tmux', 'set-window-option', 'automatic-rename', 'on']) | endif",
})
vim.api.nvim_create_autocmd('DirChanged', {
    desc = 'Rename the tmux window to $cwd:nvim',
    group = vim.api.nvim_create_augroup('my.tmux.rename_window', { clear = true }),
    command = "if !empty($TMUX) | call system(['tmux', 'rename-window', fnamemodify(v:event.cwd, ':t') . ':nvim']) | endif",
})

vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'Disable diagnostics in all windows with diff enabled',
    group = vim.api.nvim_create_augroup('my.diff.disable_diagnostics'),
    callback = function()
        for _, winid in ipairs(vim.api.nvim_list_wins()) do
            if vim.wo[winid].diff then
                vim.diagnostic.enable(false, { bufnr = vim.api.nvim_win_get_buf(winid) })
            end
        end
    end,
})
vim.api.nvim_create_autocmd('OptionSet', {
    desc = 'Toggle diagnostics when diff enabled and disabled',
    group = vim.api.nvim_create_augroup('my.diff.toggle_diagnostics'),
    pattern = 'diff',
    command = "lua vim.diagnostic.enable(vim.v.option_new ~= '1', { bufnr = 0 })",
})

vim.api.nvim_create_autocmd('BufWinEnter', {
    desc = 'Jump to last file position',
    group = vim.api.nvim_create_augroup('my.buffer.jump_to_last_position'),
    callback = function(ev)
        local pos = vim.api.nvim_buf_get_mark(ev.buf, '"')
        if pos[1] >= 1 and pos[1] <= vim.fn.line('$') and not vim.tbl_contains({ 'gitcommit', 'gitrebase' }, vim.o.filetype) then
            vim.api.nvim_win_set_cursor(0, pos)
        end
    end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'Trim trailing whitespace',
    group = vim.api.nvim_create_augroup('my.buffer.trim_trailing_whitespace'),
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd('silent! undojoin')
        vim.cmd('silent keepjumps keeppatterns %s/\\s\\+$//e')
        vim.fn.winrestview(view)
    end,
})

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufNewFile' }, {
    desc = 'Add file to v:oldfiles',
    group = vim.api.nvim_create_augroup('my.oldfiles.add'),
    callback = function(ev)
        if vim.fn.filereadable(ev.file) == 1 or ev.event == 'BufNewFile' then
            local rest = vim.tbl_filter(function(f)
                return f ~= ev.file
            end, vim.v.oldfiles)
            vim.v.oldfiles = { ev.file, unpack(rest) }
        end
    end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
    desc = 'Set buffer directory to git root',
    group = vim.api.nvim_create_augroup('my.buffer.set_buffer_working_directory'),
    callback = function(ev)
        local root = vim.fs.root(ev.buf, '.git')
        if root then
            vim.cmd.bcd(root)
        end
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'Start treesitter highlighting',
    group = vim.api.nvim_create_augroup('my.treesitter.highlight_start'),
    command = 'lua pcall(vim.treesitter.start)',
})

vim.api.nvim_create_autocmd({ 'TextYankPost', 'TextPutPost' }, {
    desc = 'Highlight yanked and put text',
    group = vim.api.nvim_create_augroup('my.yank.highlight'),
    command = 'lua vim.hl.hl_op({ timeout = 500 })',
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
    desc = 'Use relative line numbers in focused window when not in insert mode',
    group = vim.api.nvim_create_augroup('my.options.set_relativenumber'),
    command = "if mode() != 'i' && &number | setlocal relativenumber | endif",
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
    desc = 'Use absolute line numbers in unfocused windows or when in insert mode',
    group = vim.api.nvim_create_augroup('my.options.unset_relativenumber'),
    command = 'if &number | set norelativenumber | endif',
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'Remove c, r, and o from formatoptions after any ftplugin may have modified them',
    group = vim.api.nvim_create_augroup('my.options.remove_formatoptions'),
    callback = function()
        vim.cmd('setlocal formatoptions-=c')
        vim.cmd('setlocal formatoptions-=r')
        vim.cmd('setlocal formatoptions-=o')
    end,
})
