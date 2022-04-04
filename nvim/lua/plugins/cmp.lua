local cmp = require 'cmp'

cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'nvim_lua' },
  },
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,preview,noinsert',
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
    ['<cr>'] = cmp.mapping.confirm { select = true },
  },
  sorting = {
    comparators = { cmp.config.compare.sort_text },
  },
}
