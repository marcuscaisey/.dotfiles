local cmp = require 'cmp'
local utils = require 'plugins.cmp.utils'

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
      elseif utils.should_tab_out() then
        utils.feedkeys('<right>', 'i')
      else
        fallback()
      end
    end,
    ['<cr>'] = cmp.mapping.confirm { select = true },
  },
  formatting = {
    format = require('lspkind').cmp_format {
      mode = 'symbol',
      preset = 'codicons',
    },
  },
  sorting = {
    comparators = { cmp.config.compare.sort_text },
  },
}

cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
