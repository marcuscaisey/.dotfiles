local ok, mini_completion = pcall(require, 'mini.completion')
if not ok then
    return
end
mini_completion.setup({
    lsp_completion = { source_func = 'omnifunc', auto_setup = false },
    mappings = { force_twostep = '<C-N>' },
})

vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Enable completion',
    group = vim.api.nvim_create_augroup('my.mini.completion'),
    callback = function(ev)
        local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
        if client:supports_method('textDocument/completion') then
            vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
        end
    end,
})
