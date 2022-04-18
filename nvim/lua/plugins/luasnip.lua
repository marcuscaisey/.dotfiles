local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local ps = ls.parser.parse_snippet
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep
local nonempty = require('luasnip.extras').nonempty
local strings = require 'plenary.strings'
local types = require 'luasnip.util.types'

ls.config.setup {
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
}

ls.add_snippets('lua', {}, {
  key = 'lua',
})

ls.add_snippets('go', {}, {
  key = 'go',
})
