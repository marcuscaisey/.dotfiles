local ok, blink = pcall(require, 'blink.cmp')
if not ok then
  return
end

blink.setup({
  keymap = {
    preset = 'none',
    ['<C-E>'] = { 'cancel', 'fallback' },
    ['<C-Y>'] = { 'select_and_accept', 'fallback' },
    ['<C-N>'] = { 'show', 'select_next', 'fallback' },
    ['<C-P>'] = { 'show', 'select_prev', 'fallback' },
  },
  completion = {
    list = { selection = 'auto_insert' },
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
    documentation = { auto_show = true },
  },
  appearance = { use_nvim_cmp_as_default = true },
  signature = { enabled = true },
})
