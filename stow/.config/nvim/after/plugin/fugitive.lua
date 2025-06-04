vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('fugitive_custom', { clear = true }),
  pattern = { 'fugitive:///*' },
  desc = 'Add mapping to Fugitive commit patch buffers to yank hash with <leader>y',
  callback = function(args)
    vim.keymap.set('n', '<Leader>yy', function()
      local filepath = vim.api.nvim_buf_get_name(0)
      local hash = filepath:match('.+/%.git//(.+)')
      vim.fn.setreg('"', hash)
      vim.fn.setreg('*', hash)
      print(string.format('Yanked %s', hash))
    end, { desc = 'Yank the hash of the commit patch', buffer = true })

    local clients = vim.lsp.get_clients({ bufnr = args.buf })
    for _, client in ipairs(clients) do
      vim.lsp.buf_detach_client(args.buf, client.id)
    end
  end,
})

vim.keymap.set('n', '<Leader>gb', '<Cmd>Git blame<CR>', { desc = ':Git blame' })
