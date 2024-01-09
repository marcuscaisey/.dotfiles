local ok, luasnip = pcall(require, 'luasnip')
if not ok then
  return
end
local types = require('luasnip.util.types')

luasnip.config.setup({
  updateevents = 'TextChanged,TextChangedI',
  delete_check_events = 'TextChanged',
  history = true,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { '← choices', 'LuasnipChoiceVirtualText' } },
      },
    },
  },
})

luasnip.add_snippets('go', {
  luasnip.parser.parse_snippet('dp', 'fmt.Printf("$1: %+v\\n", $1)'),
  luasnip.parser.parse_snippet(
    'jp',
    [[
      $1Bytes, err := json.MarshalIndent($1, "", "  ")
      if err != nil {
          panic(err)
      }
      fmt.Printf("$1: %+v\n", string($1Bytes))
  ]]
  ),
}, {
  key = 'go',
})

vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*:s',
  callback = function()
    if luasnip.in_snippet() then
      local keys = vim.api.nvim_replace_termcodes('<c-r>_', true, false, true)
      vim.api.nvim_feedkeys(keys, 'n', false)
    end
  end,
  group = vim.api.nvim_create_augroup('luasnip-custom', { clear = true }),
  desc = 'Send replaced node text to the black hole register',
})

vim.keymap.set({ 'i', 's' }, '<c-j>', function()
  if luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  end
end)
vim.keymap.set({ 'i', 's' }, '<c-k>', function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end)
vim.keymap.set({ 'i', 's' }, '<c-h>', function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end)
vim.keymap.set('n', '<leader><leader>s', function()
  vim.cmd.source('~/.dotfiles/stow/.config/nvim/after/plugin/luasnip.lua')
  print('Reloaded snippets')
end)
