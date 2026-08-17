-------------------------------------------------------------------------------
-- General Options
-------------------------------------------------------------------------------
vim.o.clipboard = 'unnamed'
vim.o.colorcolumn = '+1'
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.exrc = true
vim.o.ignorecase = true
vim.o.laststatus = 3
vim.o.number = true
vim.o.pumheight = 10
vim.o.relativenumber = true
vim.o.scrolloff = 10
vim.o.shada = "'500"
vim.o.shiftwidth = 4
vim.o.signcolumn = 'yes:2'
vim.o.smartcase = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.updatetime = 100

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

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

vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
    desc = 'Use relative line numbers in focused window when not in insert mode',
    group = vim.api.nvim_create_augroup('options.set_relativenumber'),
    command = "if mode() != 'i' && &number | setlocal relativenumber | endif",
})
vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
    desc = 'Use absolute line numbers in unfocused windows or when in insert mode',
    group = vim.api.nvim_create_augroup('options.unset_relativenumber'),
    command = 'if &number | set norelativenumber | endif',
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'Remove c, r, and o from formatoptions after any ftplugin may have modified them',
    group = vim.api.nvim_create_augroup('options.remove_formatoptions'),
    callback = function()
        vim.cmd('setlocal formatoptions-=c')
        vim.cmd('setlocal formatoptions-=r')
        vim.cmd('setlocal formatoptions-=o')
    end,
})

vim.keymap.set('n', 'yow', '<Cmd>setlocal wrap!<CR>', { desc = 'Toggle line wrapping' })

-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('PackChanged', {
    desc = 'Run post installation commands',
    group = vim.api.nvim_create_augroup('pack.post_install_commands'),
    callback = function(ev)
        local active, kind, spec = ev.data.active, ev.data.kind, ev.data.spec
        if not (kind == 'update' or kind == 'install') then
            return
        end
        if spec.name == 'nvim-treesitter' then
            if not active then
                vim.cmd.packadd('nvim-treesitter')
            end
            vim.cmd.TSUpdate()
        end
    end,
})

vim.pack.add({
    { src = 'https://github.com/barrettruth/canola.nvim' },
    { src = 'https://github.com/bkad/camelcasemotion' },
    { src = 'https://github.com/gbprod/nord.nvim' },
    { src = 'https://github.com/ibhagwan/fzf-lua' },
    { src = 'https://github.com/inkarkat/vim-ConflictMotions' },
    { src = 'https://github.com/inkarkat/vim-CountJump' }, -- Required for vim-ConflictMotions
    { src = 'https://github.com/inkarkat/vim-ReplaceWithRegister' },
    { src = 'https://github.com/inkarkat/vim-ingo-library' }, -- Required for vim-CountJump
    { src = 'https://github.com/jake-stewart/multicursor.nvim' },
    { src = 'https://github.com/kosayoda/nvim-lightbulb' },
    { src = 'https://github.com/kyazdani42/nvim-web-devicons' },
    { src = 'https://github.com/kylechui/nvim-surround' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = 'https://github.com/linrongbin16/gitlinker.nvim' },
    { src = 'https://github.com/marcuscaisey/olddirs.nvim' },
    { src = 'https://github.com/marcuscaisey/please.nvim' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/michaeljsmith/vim-indent-object' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
    { src = 'https://github.com/tpope/vim-fugitive' },
})
-- Set so that ReplaceWithRegister doesn't create default mappings before we can override them in
-- after/plugin/replacewithregister.lua
vim.g.loaded_ReplaceWithRegister = true

vim.cmd.packadd('nvim.undotree')

-------------------------------------------------------------------------------
-- Colorscheme
-------------------------------------------------------------------------------
local ok, nord = pcall(require, 'nord')
if ok then
    nord.setup({
        ---@param colors Nord.Palette
        on_highlights = function(highlights, colors)
            for _, kind in ipairs(vim.lsp.protocol.CompletionItemKind) do
                highlights['LspKind' .. kind] = { link = 'BlinkCmpKind' .. kind }
            end
            highlights.TreesitterContext = { fg = highlights.Normal.fg, bg = colors.polar_night.bright }
            highlights.NormalFloat.bg = colors.polar_night.bright
        end,
    })
    vim.cmd.colorscheme('nord')
end

-------------------------------------------------------------------------------
-- General Keymaps
-------------------------------------------------------------------------------
vim.g.mapleader = ' '

vim.keymap.set('n', '<C-W><', '<C-W>5<', { desc = 'Decrease window width by 5' })
vim.keymap.set('n', '<C-W>>', '<C-W>5>', { desc = 'Increase window width by 5' })
vim.keymap.set('n', '<C-W>-', '<C-W>5-', { desc = 'Decrease window height by 5' })
vim.keymap.set('n', '<C-W>+', '<C-W>5+', { desc = 'Increase window height by 5' })

vim.keymap.set('n', 'j', [[(v:count > 1 ? "m'" . v:count : "") . 'j']], { desc = '[count] lines downward linewise', expr = true })
vim.keymap.set('n', 'k', [[(v:count > 1 ? "m'" . v:count : "") . 'k']], { desc = '[count] lines upward linewise', expr = true })

vim.keymap.set('n', 'n', 'nzz', { desc = 'Repeat the latest "/" or "?" [count] times' })
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Repeat the latest "/" or "?" [count] times in opposite direction' })
vim.keymap.set('n', '[q', '<Cmd>execute "cprevious" . v:count1<CR>zz', { desc = 'Jump to [count] previous quickfix list entry' })
vim.keymap.set('n', ']q', '<Cmd>execute "cnext " . v:count1<CR>zz', { desc = 'Jump to [count] next quickfix list entry' })
vim.keymap.set('n', '[Q', '<Cmd>cfirst<CR>zz', { desc = 'Jump to first quickfix list entry' })
vim.keymap.set('n', ']Q', '<Cmd>clast<CR>zz', { desc = 'Jump to previous quickfix list entry' })
vim.keymap.set('n', '[<C-Q>', '<Cmd>cpfile<CR>zz', { desc = 'Jump to quickfix list entry in previous file' })
vim.keymap.set('n', ']<C-Q>', '<Cmd>cnfile<CR>zz', { desc = 'Jump to quickfix list entry in next file' })
vim.keymap.set('n', '[l', '<Cmd>execute "lprevious" . v:count1<CR>zz', { desc = 'Jump to [count] previous location list entry' })
vim.keymap.set('n', ']l', '<Cmd>execute "lnext " . v:count1<CR>zz', { desc = 'Jump to [count] next location list entry' })
vim.keymap.set('n', '[L', '<Cmd>lfirst<CR>zz', { desc = 'Jump to first location list entry' })
vim.keymap.set('n', ']L', '<Cmd>llast<CR>zz', { desc = 'Jump to previous location list entry' })
vim.keymap.set('n', '[<C-L>', '<Cmd>lpfile<CR>zz', { desc = 'Jump to location list entry in previous file' })
vim.keymap.set('n', ']<C-L>', '<Cmd>lnfile<CR>zz', { desc = 'Jump to location list entry in next file' })

--------------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------------
vim.lsp.enable({
    'basedpyright',
    'bashls',
    'clangd',
    'dartls',
    'efm',
    'eslint',
    'fish_lsp',
    'golangci_lint_ls',
    'gopls',
    'intelephense',
    'jdtls',
    'jsonls',
    'loxls',
    'lua_ls',
    'marksman',
    'please',
    'rust_analyzer',
    'stylua',
    'ts_ls',
    'vimls',
    'yamlls',
    'zls',
})

if vim.env.NVIM_ENABLE_LSP_DEVTOOLS then
    for _, config in ipairs(vim.lsp.get_configs({ enabled = true })) do
        local cmd = config.cmd
        if type(cmd) == 'table' and (vim.env.NVIM_ENABLE_LSP_DEVTOOLS == config.name or vim.env.NVIM_ENABLE_LSP_DEVTOOLS == 'all') then
            vim.lsp.config(config.name, { cmd = { 'lsp-devtools', 'agent', '--', unpack(cmd) } })
        end
    end
end

vim.lsp.codelens.enable()

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Enable completion if the server supports it',
    group = vim.api.nvim_create_augroup('lsp.completion'),
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, {
                convert = function(item)
                    return { kind_hlgroup = 'LspKind' .. vim.lsp.protocol.CompletionItemKind[item.kind] }
                end,
                autotrigger = true,
            })
            vim.bo[ev.buf].complete = 'o'
        end
    end,
})

local original_formatexpr = vim.lsp.formatexpr
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.formatexpr = function(opts)
    original_formatexpr(vim.tbl_deep_extend('keep', opts or {}, { timeout_ms = 5000 }))
end

vim.api.nvim_create_autocmd('LspProgress', {
    desc = 'Echo progress message',
    group = vim.api.nvim_create_augroup('lsp.progress_echo'),
    callback = function(ev)
        local value = ev.data.params.value
        vim.api.nvim_echo({ { value.message or 'done' } }, false, {
            id = 'lsp',
            kind = 'progress',
            source = 'vim.lsp',
            title = value.title,
            status = value.kind ~= 'end' and 'running' or 'success',
            percent = value.percentage,
        })
    end,
})

--- Copied from $VIMRUNTIME/runtime/lua/vim/lsp.lua
--- @param bufnr integer
--- @param config vim.lsp.Config
local function start_config(bufnr, config)
    return vim.lsp.start(config, {
        bufnr = bufnr,
        reuse_client = config.reuse_client,
        _root_markers = config.root_markers,
    })
end

vim.api.nvim_create_autocmd('FileType', {
    desc = "When 'filetype' is set to foo.gotmpl, start the servers for filetypes foo and gotmpl",
    group = vim.api.nvim_create_augroup('lsp.gotmpl_servers'),
    pattern = '*.gotmpl',
    callback = function(ev)
        for filetype in vim.gsplit(ev.match, '.', { plain = true }) do
            for _, config in ipairs(vim.lsp.get_configs({ enabled = true })) do
                if vim.list_contains(config.filetypes, filetype) then
                    vim.lsp.start(config, { bufnr = ev.buf })
                    if type(config.root_dir) == 'function' then
                        config.root_dir(ev.buf, function(root_dir)
                            config.root_dir = root_dir
                            vim.schedule(function()
                                start_config(ev.buf, config)
                            end)
                        end)
                    else
                        start_config(ev.buf, config)
                    end
                end
            end
        end
    end,
})

vim.keymap.set('n', '<Leader>f', '<Cmd>lua vim.lsp.buf.format()<CR>', { desc = 'Format buffer' })

-------------------------------------------------------------------------------
-- Completion
-------------------------------------------------------------------------------
vim.o.autocomplete = true
vim.o.autocompletedelay = 250
vim.o.complete = '.'
vim.o.completeopt = 'fuzzy,menuone,noinsert,popup'
vim.cmd('set shortmess+=c')
vim.o.wildmode = 'noselect:lastused,full'
vim.o.wildoptions = 'fuzzy,pum'

vim.api.nvim_create_autocmd('CmdlineChanged', {
    desc = 'Trigger command line completion',
    group = vim.api.nvim_create_augroup('autocomplete.trigger_cmdline_autocomplete'),
    pattern = { ':', '/', '?' },
    command = 'call wildtrigger()',
})

vim.keymap.set('i', '<CR>', 'pumvisible() ? "<C-E><CR>" : "<CR>"', { desc = 'Close popup menu if visible, then <CR>', expr = true })
vim.keymap.set('i', '<C-Y>', 'pumvisible() && complete_info().selected == -1 ? "<C-N><C-Y>" : "<C-Y>"', {
    desc = 'Select the first popup item if nothing is selected, then <C-Y>',
    expr = true,
})
vim.keymap.set('i', '<C-N>', 'pumvisible() ? "<Down>" : "<C-N>"', {
    desc = "Select the next match, as if CTRL-N was used, but don't insert it",
    expr = true,
    replace_keycodes = false,
})
vim.keymap.set('i', '<C-P>', 'pumvisible() ? "<Up>" : "<C-P>"', {
    desc = "Select the previous match, as if CTRL-P was used, but don't insert it",
    expr = true,
    replace_keycodes = false,
})

--------------------------------------------------------------------------------
-- Diagnostics
--------------------------------------------------------------------------------
local signs = {
    [vim.diagnostic.severity.ERROR] = ' ',
    [vim.diagnostic.severity.WARN] = ' ',
    [vim.diagnostic.severity.INFO] = ' ',
    [vim.diagnostic.severity.HINT] = '󰌵 ',
}
vim.diagnostic.config({
    virtual_text = { source = true },
    signs = { text = signs },
    float = { source = true },
    severity_sort = true,
})

vim.keymap.set('n', 'yoe', '<Cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>', { desc = 'Toggle diagnostics' })

--------------------------------------------------------------------------------
-- Status Line
--------------------------------------------------------------------------------
local ok, devicons = pcall(require, 'nvim-web-devicons')
if not ok then
    return
end

vim.o.statusline = table.concat({
    ' ',
    '%(%{% get(b:, "statusline_git", "") %}  %)',
    '%{% get(g:, "statusline_file", "") %}',
    '%=',
    '%(%{% get(b:, "statusline_lsp_clients", "") %}  %)',
    '%(%{% get(b:, "statusline_diagnostics", "") %}  %)',
    '%#StatusLine# %l:%v %p%%',
    ' ',
})

vim.api.nvim_create_autocmd('User', {
    desc = 'Update statusline git section',
    group = vim.api.nvim_create_augroup('statusline.git'),
    pattern = 'GitSignsUpdate',
    callback = function(ev)
        if not ev.data then
            return
        end
        local bufnr = ev.data.buffer
        local status = vim.b[bufnr].gitsigns_status_dict
        if not status then
            return
        end
        local icon, icon_hl_group = devicons.get_icon(nil, 'git')
        local parts = { ('%%#%s#%s %%#StatusLine#%s'):format(icon_hl_group, icon, status.head) }
        if status.added and status.added > 0 then
            table.insert(parts, '%#GitSignsAdd#+' .. status.added)
        end
        if status.changed and status.changed > 0 then
            table.insert(parts, '%#GitSignsChange#~' .. status.changed)
        end
        if status.removed and status.removed > 0 then
            table.insert(parts, '%#GitSignsDelete#-' .. status.removed)
        end
        vim.b[bufnr].statusline_git = table.concat(parts, ' ')
        vim.cmd.redrawstatus()
    end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'DirChanged' }, {
    desc = 'Update statusline file section',
    group = vim.api.nvim_create_augroup('statusline.file'),
    callback = function()
        local icon, icon_hl_group = devicons.get_icon(vim.api.nvim_buf_get_name(0), nil, { default = true })
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
        vim.g.statusline_file = ('%%#%s#%s %%#StatusLine#%%f %%(%%h%%w%%m%%r %%)%%#qfLineNr#%s'):format(icon_hl_group, icon, cwd)
        vim.cmd.redrawstatus()
    end,
})

vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
    desc = 'Update statusline lsp clients section',
    group = vim.api.nvim_create_augroup('statusline.lsp_clients'),
    callback = function(ev)
        local client_names = {}
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = ev.buf })) do
            if not client:is_stopped() and not vim.tbl_contains(client_names, client.name) then
                table.insert(client_names, client.name)
            end
        end
        vim.b[ev.buf].statusline_lsp_clients = '%#StatusLine# ' .. table.concat(client_names, ', ')
        vim.cmd.redrawstatus()
    end,
})

vim.api.nvim_create_autocmd('DiagnosticChanged', {
    desc = 'Update statusline diagnostics section',
    group = vim.api.nvim_create_augroup('statusline.diagnostics'),
    callback = function(ev)
        local bufnr = ev.buf
        vim.b[bufnr].statusline_diagnostics = vim.diagnostic.status(bufnr)
        vim.cmd.redrawstatus()
    end,
})

--------------------------------------------------------------------------------
-- Quickfix List
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    desc = 'Sort quickfix list items',
    group = vim.api.nvim_create_augroup('quickfix.sort'),
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

vim.keymap.set('n', '<Leader>q', '<Cmd>execute getqflist({"winid": 0}).winid > 0 ? "cclose" : "copen"<CR>', { desc = 'Toggle quickfix list' })
vim.keymap.set('n', '<Leader>l', '<Cmd>execute getloclist(0, {"winid": 0}).winid > 0 ? "lclose" : "lopen"<CR>', { desc = 'Toggle location list' })

--------------------------------------------------------------------------------
-- Argument List
--------------------------------------------------------------------------------
vim.keymap.set('n', '<Leader>aa', '<Cmd>$argedit % | argdedupe | args<CR>', { desc = 'Add file to argument list' })
vim.keymap.set('n', '<Leader>AA', '<Cmd>args<CR>', { desc = 'List argument list' })
vim.keymap.set('n', '<Leader>ac', '<Cmd>argdelete * | args<CR>', { desc = 'Clear argument list' })
for i = 0, 9 do
    -- stylua: ignore start
    vim.keymap.set('n', string.format('<Leader>%d', i), string.format('<Cmd>argument %d | args<CR>', i), { desc = string.format('Jump to file %d in argument list', i) })
    -- stylua: ignore end
end

--------------------------------------------------------------------------------
-- Sessions
--------------------------------------------------------------------------------
vim.cmd('set sessionoptions+=globals')

---@class QuickfixState
---@field items vim.quickfix.entry[]
---@field idx integer
---@field is_open boolean

vim.api.nvim_create_autocmd('SessionWritePre', {
    desc = 'Save quickfix state',
    group = vim.api.nvim_create_augroup('session.save_quickfix'),
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
    group = vim.api.nvim_create_augroup('session.restore_quickfix'),
    callback = function()
        if not vim.g.QuickfixState then
            return
        end
        local state = vim.json.decode(vim.g.QuickfixState) --[[@as QuickfixState]]
        if #state.items > 0 then
            vim.fn.setqflist({}, ' ', { items = state.items, idx = state.idx })
            if state.is_open then
                vim.cmd.copen()
            end
        end
    end,
})

--------------------------------------------------------------------------------
-- Tmux
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('VimLeave', {
    desc = 'Turn tmux automatic window renaming on',
    group = vim.api.nvim_create_augroup('tmux.auto_window_renaming', { clear = true }),
    command = "if !empty($TMUX) | call system(['tmux', 'set-window-option', 'automatic-rename', 'on']) | endif",
})

vim.api.nvim_create_autocmd('DirChanged', {
    desc = 'Rename the tmux window to $cwd:nvim',
    group = vim.api.nvim_create_augroup('tmux.rename_window', { clear = true }),
    command = "if !empty($TMUX) | call system(['tmux', 'rename-window', fnamemodify(v:event.cwd, ':t') . ':nvim']) | endif",
})

--------------------------------------------------------------------------------
-- Diffs
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'Disable diagnostics in all windows with diff enabled',
    group = vim.api.nvim_create_augroup('diff.disable_diagnostics'),
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
    group = vim.api.nvim_create_augroup('diff.toggle_diagnostics'),
    pattern = 'diff',
    command = "lua vim.diagnostic.enable(vim.v.option_new ~= '1', { bufnr = 0 })",
})

vim.keymap.set('n', 'yod', '<Cmd>execute &diff ? "diffoff" : "diffthis"<CR>', { desc = 'Toggle diff in window' })
vim.keymap.set('n', 'yoD', '<Cmd>diffoff!<CR>', { desc = 'Switch off diff in all windows' })

--------------------------------------------------------------------------------
-- Miscellaneous
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd('BufWinEnter', {
    desc = 'Jump to last file position',
    group = vim.api.nvim_create_augroup('buffer.jump_to_last_position'),
    callback = function(ev)
        local pos = vim.api.nvim_buf_get_mark(ev.buf, '"')
        if pos[1] >= 1 and pos[1] <= vim.fn.line('$') and not vim.tbl_contains({ 'gitcommit', 'gitrebase' }, vim.o.filetype) then
            vim.api.nvim_win_set_cursor(0, pos)
        end
    end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'Trim trailing whitespace',
    group = vim.api.nvim_create_augroup('buffer.trim_trailing_whitespace'),
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd('silent! undojoin')
        vim.cmd('silent keepjumps keeppatterns %s/\\s\\+$//e')
        vim.fn.winrestview(view)
    end,
})

vim.keymap.set('n', 'gq', function()
    local view = vim.fn.winsaveview()
    vim.api.nvim_create_autocmd('CursorMoved', {
        group = vim.api.nvim_create_augroup('formatting.restore_cursor'),
        buf = 0,
        once = true,
        desc = 'Restore view after formatting',
        callback = function()
            vim.fn.winrestview(view)
        end,
    })
    return 'gq'
end, { expr = true, desc = 'gq{motion} formats the lines that {motion} moves over' })

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufNewFile' }, {
    desc = 'Add file to v:oldfiles',
    group = vim.api.nvim_create_augroup('oldfiles.add'),
    callback = function(ev)
        if vim.fn.filereadable(ev.file) == 1 or ev.event == 'BufNewFile' then
            local rest = vim.tbl_filter(function(f)
                return f ~= ev.file
            end, vim.v.oldfiles)
            vim.v.oldfiles = { ev.file, unpack(rest) }
        end
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    desc = 'Start treesitter highlighting',
    group = vim.api.nvim_create_augroup('treesitter.highlight_start'),
    command = 'lua pcall(vim.treesitter.start)',
})

vim.api.nvim_create_autocmd({ 'TextYankPost', 'TextPutPost' }, {
    desc = 'Highlight yanked and put text',
    group = vim.api.nvim_create_augroup('yank.highlight'),
    command = 'lua vim.hl.hl_op({ timeout = 500 })',
})

---@param s string
local function yank(s)
    vim.fn.setreg('"', s)
    vim.fn.setreg('*', s)
    print(string.format('Yanked %s', s))
end

---@param path string
---@return string?
---@return string? errmsg
local function git_root(path)
    local root = vim.fs.root(path, '.git')
    if not root then
        return nil, 'locating git root: not in a git repo'
    end
    return root
end

vim.keymap.set('n', '<Leader>yy', function()
    local path = vim.api.nvim_buf_get_name(0)
    local git_root, errmsg = git_root(vim.api.nvim_buf_get_name(0))
    if not git_root then
        vim.notify(string.format('Yanking path: %s', errmsg), vim.log.levels.ERROR)
        return
    end
    local rel_path = vim.fs.relpath(git_root, path)
    ---@cast rel_path -nil
    yank(rel_path)
end, { desc = 'Yank the path of the current buffer relative to the git root' })

vim.keymap.set('n', '<Leader>YY', function()
    yank(vim.api.nvim_buf_get_name(0))
end, { desc = 'Yank the absolute path of the current buffer' })
