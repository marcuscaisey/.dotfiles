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
  fuzzy = {
    frecency = { enabled = false },
    use_proximity = false,
  },
  snippets = {
    score_offset = 0,
  },
  completion = {
    accept = {
      auto_brackets = { enabled = false },
    },
    menu = {
      draw = {
        columns = { { 'label' }, { 'kind' } },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 0,
    },
  },
})
