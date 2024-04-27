local ok, cmp = pcall(require, 'cmp')
if not ok then
  return
end

local source_name_to_menu = {
  nvim_lsp = '[LSP]',
  buffer = '[BUFFER]',
}

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<c-space>'] = cmp.mapping.complete(),
  }),
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
  view = {
    ---@diagnostic disable-next-line: missing-fields
    entries = {
      follow_cursor = true,
    },
  },
})
