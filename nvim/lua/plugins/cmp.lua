local cmp = require 'cmp'

local source_name_to_menu = {
  nvim_lsp = '[LSP]',
  buffer = '[BUFFER]',
  nvim_lua = '[LUA]',
  luasnip = '[SNIP]',
  path = '[PATH]',
}

cmp.setup {
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'nvim_lua' },
    { name = 'path' },
  }, {
    { name = 'buffer' },
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
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
    comparators = { cmp.config.compare.sort_text },
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = source_name_to_menu[entry.source.name]
      return vim_item
    end,
  },
}
