local hl_groups_by_file_type = {}

---@param stat uv.fs_stat.result
---@return string?
local function file_type_hl_group(stat)
    local file_type = stat.type
    if file_type == 'file' and bit.band(stat.mode, tonumber('111', 8)) ~= 0 then
        file_type = 'executable'
    end
    return hl_groups_by_file_type[file_type]
end

local file_types_by_code = {
    di = 'directory',
    ex = 'executable',
    fi = 'file',
    pi = 'fifo',
    so = 'socket',
    bd = 'block',
    cd = 'char',
    ln = 'link',
}
for item in vim.gsplit(vim.env.LS_COLORS or '', ':') do
    local code, format = item:match('([^=]+)=([^=]+)')
    if not code then
        goto continue
    end
    local file_type = file_types_by_code[code]
    if not file_type and code ~= 'or' then
        goto continue
    end

    local val = {} ---@type vim.api.keyset.highlight
    for style_str in vim.gsplit(format, ';') do
        local style = tonumber(style_str)
        if style == 0 then
        elseif style == 1 then
            val.bold = true
        elseif style == 4 then
            val.underline = true
        elseif 30 <= style and style <= 37 then
            val.ctermfg = style - 30
            val.fg_indexed = true
        else
            vim.schedule(function()
                local msg = string.format('Unknown style %d used by LS_COLORS code %q', style, code)
                vim.api.nvim_echo({ { msg, 'WarningMsg' } }, true)
            end)
        end
    end

    if code == 'or' then
        vim.api.nvim_set_hl(0, 'DirBufferBrokenLinkArrow', val)
        val.underline = true
        vim.api.nvim_set_hl(0, 'DirBufferBrokenLinkTarget', val)
    else
        local name = string.format('DirBuffer%s', file_type:gsub('^(%l)', string.upper))
        hl_groups_by_file_type[file_type] = name
        vim.api.nvim_set_hl(0, name, val)
    end

    ::continue::
end

vim.api.nvim_set_hl(0, 'DirBufferDefaultFileIcon', { ctermfg = 66, fg = '#6d8086' })

local ns = vim.api.nvim_create_namespace('my.dir.decorate')
vim.api.nvim_create_autocmd('User', {
    desc = 'Decorate the directory buffer',
    group = vim.api.nvim_create_augroup('my.dir.decorate'),
    pattern = 'DirReadPost',
    callback = function(args)
        local bufnr = args.buf
        vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
        local dir = vim.api.nvim_buf_get_name(bufnr)
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        if vim.deep_equal(lines, { '' }) then
            return
        end
        for i, name in ipairs(lines) do
            local row = i - 1

            if name:match('/$') then
                vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
                    virt_text = { { ' ', 'Directory' } },
                    virt_text_pos = 'inline',
                })
            else
                local icon, icon_hl_group
                local ok, devicons = pcall(require, 'nvim-web-devicons')
                if ok then
                    icon, icon_hl_group = devicons.get_icon(name, nil, { default = true })
                else
                    icon = ''
                    icon_hl_group = 'DirBufferDefaultFileIcon'
                end
                vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
                    virt_text = { { icon .. ' ', icon_hl_group } },
                    virt_text_pos = 'inline',
                })
            end

            local path = vim.fs.joinpath(dir, (name:gsub('/$', '')))
            local stat = vim.uv.fs_lstat(path)
            if not stat then
                goto continue
            end
            local hl_group = file_type_hl_group(stat)
            if hl_group then
                vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
                    end_row = row,
                    end_col = #name,
                    hl_group = hl_group,
                })
            end
            if stat.type ~= 'link' then
                goto continue
            end

            local arrow_hl_group = 'DirBufferBrokenLinkArrow'
            local target_hl_group = 'DirBufferBrokenLinkTarget'
            local target = vim.uv.fs_readlink(path)
            if target then
                local stat = vim.uv.fs_lstat(vim.fs.abspath(target, { cwd = dir }))
                if stat then
                    if stat.type == 'directory' then
                        target = target .. '/'
                    end
                    arrow_hl_group = 'Dimmed'
                    target_hl_group = file_type_hl_group(stat) or 'Dimmed'
                end
            else
                target = '?'
            end
            vim.api.nvim_buf_set_extmark(bufnr, ns, row, 0, {
                virt_text = {
                    { '-> ', arrow_hl_group },
                    { target, target_hl_group },
                },
                virt_text_pos = 'eol',
            })

            ::continue::
        end
    end,
})
