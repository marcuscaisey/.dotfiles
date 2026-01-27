local ok, blink = pcall(require, 'blink.cmp')
if not ok then
  return
end

blink.setup({
  keymap = {
    ['<C-N>'] = { 'show', 'select_next', 'fallback_to_mappings' },
    ['<C-P>'] = { 'show', 'select_prev', 'fallback_to_mappings' },
    ['<C-S>'] = { 'show_signature', 'hide_signature', 'fallback' },
  },
  fuzzy = {
    frecency = { enabled = false },
    use_proximity = false,
  },
  snippets = { score_offset = 0 },
  signature = { enabled = true },
  completion = {
    accept = {
      auto_brackets = { enabled = false },
    },
    documentation = { auto_show = true },
    menu = {
      draw = {
        columns = { { 'label' }, { 'kind' } },
      },
    },
  },
})
