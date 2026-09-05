-- Increase/decrease window size in increments of 5
vim.keymap.set('n', '<C-W><', '<C-W>5<')
vim.keymap.set('n', '<C-W>>', '<C-W>5>')
vim.keymap.set('n', '<C-W>-', '<C-W>5-')
vim.keymap.set('n', '<C-W>+', '<C-W>5+')

-- [count]j and [count]k motions are added to the jump list when count > 1
vim.keymap.set('n', 'j', [[(v:count > 1 ? "m'" . v:count : "") . 'j']], { expr = true })
vim.keymap.set('n', 'k', [[(v:count > 1 ? "m'" . v:count : "") . 'k']], { expr = true })

local post_jump_zz_keymaps =
    { 'n', 'N', '[q', ']q', '[Q', ']Q', '[<C-Q>', ']<C-Q>', '[l', ']l', '[L', ']L', '[<C-L>', ']<C-L>', '<C-]>', 'g]', 'g<C-]>' }
vim.api.nvim_create_autocmd('CmdAtom', {
    group = vim.api.nvim_create_augroup('my.keymaps.post_jump_zz'),
    desc = string.format('Redraw cursor line at center of window after %s', table.concat(post_jump_zz_keymaps, ', ')),
    callback = function(ev)
        local data = ev.data ---@type vim.event.cmdatom.data
        if vim.list_contains(post_jump_zz_keymaps, data.cmd or vim.fn.keytrans(data.lhs)) then
            vim.schedule(function()
                vim.cmd('normal! zz')
            end)
        end
    end,
})

-- Toggle options
vim.keymap.set('n', 'yow', '<Cmd>setlocal wrap!<CR>')
vim.keymap.set('n', 'yoe', '<Cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>')
vim.keymap.set('n', 'yod', '<Cmd>execute &diff ? "diffoff" : "diffthis"<CR>')
vim.keymap.set('n', 'yoD', '<Cmd>diffoff!<CR>')

-- <CR> closes the popup menu instead of accepting the current selection
vim.keymap.set('i', '<CR>', 'pumvisible() ? "<C-E><CR>" : "<CR>"', { expr = true })

-- Toggle quickfix / location list
vim.keymap.set('n', '<Leader>q', '<Cmd>execute getqflist({"winid": 0}).winid > 0 ? "cclose" : "copen"<CR>')
vim.keymap.set('n', '<Leader>l', '<Cmd>execute getloclist(0, {"winid": 0}).winid > 0 ? "lclose" : "lopen"<CR>')

-- Argument list
vim.keymap.set('n', '<Leader>aa', '<Cmd>$argedit % | argdedupe | args<CR>')
vim.keymap.set('n', '<Leader>AA', '<Cmd>args<CR>')
vim.keymap.set('n', '<Leader>ac', '<Cmd>argdelete * | args<CR>')
for i = 0, 9 do
    vim.keymap.set('n', string.format('<Leader>%d', i), string.format('<Cmd>argument %d | args<CR>', i))
end

vim.keymap.set({ 'n', 'x' }, ']n', [[/^\(<\{7}<\@!\||\{7}|\@!\|=\{7}=\@!\|>\{7}>\@!\)<CR>]], {
    silent = true,
    desc = 'Jump to next git conflict marker (<<<<<<<, |||||||, =======, >>>>>>>)',
})
vim.keymap.set({ 'n', 'x' }, '[n', [[?^\(<\{7}<\@!\||\{7}|\@!\|=\{7}=\@!\|>\{7}>\@!\)<CR>]], {
    silent = true,
    desc = 'Jump to previous git conflict marker (<<<<<<<, |||||||, =======, >>>>>>>)',
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

-- Stop cursor from being moved to top of buffer after gq
vim.keymap.set('n', 'gq', function()
    local view = vim.fn.winsaveview()
    local prev_operatorfunc = vim.go.operatorfunc
    vim.go.operatorfunc = function()
        vim.cmd('normal! `[V`]gq')
        vim.fn.winrestview(view)
        vim.go.operatorfunc = prev_operatorfunc
    end
    return 'g@'
end, { expr = true })
