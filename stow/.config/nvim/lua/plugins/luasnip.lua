local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local extras = require('luasnip.extras')
local rep = extras.rep
local fmt = require('luasnip.extras.fmt').fmt
local types = require('luasnip.util.types')

ls.config.setup({
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

ls.add_snippets('go', {
  s('dp', fmt('fmt.Printf("{}: %+v\\n", {})', { rep(1), i(1) })),
  s(
    'jp',
    fmt(
      [[
        {}Bytes, err := json.MarshalIndent({}, "", "  ")
        if err != nil {{
            panic(err)
        }}
        fmt.Printf("{}: %+v\n", string({}Bytes))
      ]],
      { rep(1), i(1), rep(1), rep(1) }
    )
  ),
}, {
  key = 'go',
})

vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*:s',
  callback = function()
    if ls.in_snippet() then
      local keys = vim.api.nvim_replace_termcodes('<c-r>_', true, false, true)
      vim.api.nvim_feedkeys(keys, 'n', false)
    end
  end,
  group = vim.api.nvim_create_augroup('luasnip-custom', { clear = true }),
  desc = 'Send replaced node text to the black hole register',
})

vim.keymap.set({ 'i', 's' }, '<c-j>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end)
vim.keymap.set({ 'i', 's' }, '<c-k>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end)
vim.keymap.set({ 'i', 's' }, '<c-h>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)
vim.keymap.set('n', '<leader><leader>s', function()
  vim.cmd.source('~/.dotfiles/stow/.config/nvim/lua/plugins/luasnip.lua')
  print('Reloaded snippets')
end)
