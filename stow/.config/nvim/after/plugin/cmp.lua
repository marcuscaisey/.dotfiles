local ok, cmp = pcall(require, 'cmp')
if not ok then
  return
end
local ok, luasnip = pcall(require, 'luasnip')
if not ok then
  return
end

local source_name_to_menu = {
  nvim_lsp = '[LSP]',
  buffer = '[BUFFER]',
  luasnip = '[SNIP]',
}

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'luasnip' },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  confirmation = {
    default_behavior = cmp.ConfirmBehavior.Replace,
  },
  mapping = {
    ['<c-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<c-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<c-space>'] = cmp.mapping.complete(),
    ['<tab>'] = function(fallback)
      if cmp.visible() then
        cmp.abort()
      else
        fallback()
      end
    end,
    ['<cr>'] = cmp.mapping.confirm({ select = true }),
    ['<c-n>'] = function()
      if cmp.visible() then
        cmp.select_next_item()
      end
    end,
    ['<c-p>'] = function()
      if cmp.visible() then
        cmp.select_prev_item()
      end
    end,
  },
  sorting = {
    comparators = {
      cmp.config.compare.sort_text,
      cmp.config.compare.score,
    },
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = source_name_to_menu[entry.source.name]
      return vim_item
    end,
  },
})
