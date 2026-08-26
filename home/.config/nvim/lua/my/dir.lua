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

local ns = vim.api.nvim_create_namespace('my.dir.highlight')
vim.api.nvim_set_decoration_provider(ns, {
    on_win = function(_, _, buf)
        return vim.bo[buf].filetype == 'directory'
    end,
    ---@type fun(_: "range", winid: integer, bufnr: integer, start_row: integer, start_col: integer, end_row: integer, end_col: integer): number
    on_range = function(_, _, bufnr, start_row)
        local ret = start_row + 1

        local dir = vim.api.nvim_buf_get_name(bufnr)
        local name = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, true)[1]
        local path = vim.fs.joinpath(dir, (name:gsub('/$', '')))
        local stat = vim.uv.fs_lstat(path)
        if not stat then
            return ret
        end
        local hl_group = file_type_hl_group(stat)
        if hl_group then
            vim.api.nvim_buf_set_extmark(bufnr, ns, start_row, 0, {
                end_row = start_row,
                end_col = #name,
                hl_group = hl_group,
                ephemeral = true,
            })
        end
        if stat.type ~= 'link' then
            return ret
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
        vim.api.nvim_buf_set_extmark(bufnr, ns, start_row, 0, {
            virt_text = { { '->', arrow_hl_group } },
            virt_text_pos = 'eol',
            ephemeral = true,
        })
        vim.api.nvim_buf_set_extmark(bufnr, ns, start_row, 0, {
            virt_text = { { target, target_hl_group } },
            virt_text_pos = 'eol',
            ephemeral = true,
        })

        return ret
    end,
})
