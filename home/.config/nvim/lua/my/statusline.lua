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

vim.api.nvim_set_hl(0, 'StatusLineGitIcon', { ctermfg = 196, fg = '#f14c28' })
vim.api.nvim_create_autocmd('User', {
    desc = 'Update statusline git section',
    group = vim.api.nvim_create_augroup('my.statusline.git'),
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
        local parts = { '%#StatusLineGitIcon# %#StatusLine#' .. status.head }
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

---@param base string
---@param target string
---@return string
local function relative_path(base, target)
    -- We can't just use vim.fs.relpath(base, target) because it returns nil if base is not a parent
    -- of target
    local path_to_base = ''
    while base do
        local path_relative_to_base = vim.fs.relpath(base, target)
        if path_relative_to_base then
            return vim.fs.joinpath(path_to_base, path_relative_to_base)
        end
        base = vim.fs.dirname(base)
        path_to_base = vim.fs.joinpath(path_to_base, '..')
    end
    return ''
end

vim.api.nvim_set_hl(0, 'StatusLineDefaultFileIcon', { ctermfg = 66, fg = '#6d8086' })
vim.api.nvim_create_autocmd({ 'BufEnter', 'DirChanged' }, {
    desc = 'Update statusline file section',
    group = vim.api.nvim_create_augroup('my.statusline.file'),
    callback = function(ev)
        if vim.bo.buftype == 'terminal' then
            return
        end
        if vim.bo.filetype == 'directory' then
            vim.g.statusline_file = '%#Directory# %#StatusLine#%f '
        else
            local icon, icon_hl_group
            local ok, devicons = pcall(require, 'nvim-web-devicons')
            if ok then
                icon, icon_hl_group = devicons.get_icon(vim.api.nvim_buf_get_name(0), nil, { default = true })
            else
                icon = ''
                icon_hl_group = 'StatusLineDefaultFileIcon'
            end

            local cwd = vim.fn.getcwd()
            local filename = vim.api.nvim_buf_get_name(ev.buf)

            if filename ~= '' then
                local git_root = vim.fs.root(ev.buf, '.git')
                local in_git_root = git_root and vim.fs.relpath(git_root, filename)
                if in_git_root then
                    filename = relative_path(cwd, filename)
                end
            else
                filename = '[No Name]'
            end

            local formatted_cwd = vim.fn.fnamemodify(cwd, ':~')
            vim.g.statusline_file = (
                '%#'
                .. icon_hl_group
                .. '#'
                .. icon
                .. ' %#StatusLine#'
                .. filename
                .. ' %(%h%w%m%r %)'
                .. '%#StatusLineDirectory#'
                .. formatted_cwd
                .. '/'
            )
        end
        vim.cmd.redrawstatus()
    end,
})

vim.api.nvim_create_autocmd({ 'LspAttach', 'LspDetach' }, {
    desc = 'Update statusline lsp clients section',
    group = vim.api.nvim_create_augroup('my.statusline.lsp_clients'),
    callback = function(ev)
        local client_names = {}
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = ev.buf })) do
            if not client:is_stopped() and not vim.tbl_contains(client_names, client.name) then
                table.insert(client_names, client.name)
            end
        end
        vim.b[ev.buf].statusline_lsp_clients = '%#StatusLine#  ' .. table.concat(client_names, ', ')
        vim.cmd.redrawstatus()
    end,
})

vim.api.nvim_create_autocmd('DiagnosticChanged', {
    desc = 'Update statusline diagnostics section',
    group = vim.api.nvim_create_augroup('my.statusline.diagnostics'),
    callback = function(ev)
        local bufnr = ev.buf
        vim.b[bufnr].statusline_diagnostics = vim.diagnostic.status(bufnr)
        vim.cmd.redrawstatus()
    end,
})
