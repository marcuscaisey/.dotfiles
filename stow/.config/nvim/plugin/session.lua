---@class QuickfixState
---@field items vim.quickfix.entry[]
---@field idx integer
---@field is_open boolean

vim.api.nvim_create_autocmd('SessionWritePre', {
    desc = 'Save quickfix state',
    group = vim.api.nvim_create_augroup('session.save_quickfix', {}),
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
    group = vim.api.nvim_create_augroup('session.restore_quickfix', {}),
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
