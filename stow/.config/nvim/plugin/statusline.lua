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
    group = vim.api.nvim_create_augroup('statusline.git', {}),
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
    group = vim.api.nvim_create_augroup('statusline.file', {}),
    callback = function()
        local icon, icon_hl_group = devicons.get_icon(vim.api.nvim_buf_get_name(0), nil, { default = true })
        local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':~')
        vim.g.statusline_file = ('%%#%s#%s %%#StatusLine#%%f %%(%%h%%w%%m%%r %%)%%#StatusLineNC#%s'):format(icon_hl_group, icon, cwd)
        vim.cmd.redrawstatus()
    end,
})

vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
    desc = 'Update statusline lsp clients section',
    group = vim.api.nvim_create_augroup('statusline.lsp_clients', {}),
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
    group = vim.api.nvim_create_augroup('statusline.diagnostics', {}),
    callback = function(ev)
        local bufnr = ev.buf
        vim.b[bufnr].statusline_diagnostics = vim.diagnostic.status(bufnr)
        vim.cmd.redrawstatus()
    end,
})
