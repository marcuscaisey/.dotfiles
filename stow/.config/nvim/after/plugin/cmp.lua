local ok, cmp = pcall(require, 'cmp')
if not ok then
  return
end

local source_name_to_menu = {
  nvim_lsp = '[LSP]',
  buffer = '[BUFFER]',
  luasnip = '[SNIP]',
}

---@diagnostic disable-next-line: missing-fields
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'luasnip' },
  },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  mapping = {
    ['<c-f>'] = cmp.mapping.scroll_docs(4),
    ['<c-b>'] = cmp.mapping.scroll_docs(-4),
    ['<c-space>'] = cmp.mapping.complete(),
    ['<c-e>'] = cmp.mapping.abort(),
    ['<cr>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
    ['<c-n>'] = cmp.mapping.select_next_item(),
    ['<c-p>'] = cmp.mapping.select_prev_item(),
  },
  ---@diagnostic disable-next-line: missing-fields
  sorting = {
    comparators = {
      cmp.config.compare.sort_text,
      cmp.config.compare.score,
    },
  },
  ---@diagnostic disable-next-line: missing-fields
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = source_name_to_menu[entry.source.name]
      return vim_item
    end,
  },
})
