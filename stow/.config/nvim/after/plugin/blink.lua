local ok, blink = pcall(require, 'blink.cmp')
if not ok then
  return
end

blink.setup({
  keymap = {
    ['<C-N>'] = { 'show', 'select_next', 'fallback_to_mappings' },
    ['<C-P>'] = { 'show', 'select_prev', 'fallback_to_mappings' },
    ['<C-Y>'] = { 'select_and_accept', 'fallback_to_mappings' },
    ['<C-K>'] = {},
    ['<C-Space>'] = {},
  },
  completion = {
    accept = {
      auto_brackets = { enabled = false },
    },
    menu = {
      draw = {
        columns = { { 'label' }, { 'kind', 'source_name', gap = 1 } },
        components = {
          source_name = {
            text = function(ctx)
              return '[' .. ctx.source_name .. ']'
            end,
          },
        },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
    },
  },
  signature = { enabled = true },
})
