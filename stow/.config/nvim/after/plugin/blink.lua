local ok, blink = pcall(require, 'blink.cmp')
if not ok then
  return
end

blink.setup({
  completion = {
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
