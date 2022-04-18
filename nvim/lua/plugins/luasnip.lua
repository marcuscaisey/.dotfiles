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

ls.add_snippets('lua', {
  ps('func', 'function($1)\n  $0\nend'),
  ps('lfunc', 'local $1 = function($2)\n  $0\nend'),
  ps('mfunc', '${1:M}.$2 = function($3)\n  $0\nend'),
  ls.parser.parse_snippet('for', 'for ${1:k}, ${2:v} in pairs(${3:t}) do\n  $0\nend'),
  ls.parser.parse_snippet('fori', 'for ${1:_}, ${2:v} in ipairs(${3:t}) do\n  $0\nend'),
  ls.parser.parse_snippet('while', 'while $1 do\n  $0\nend'),
  ls.parser.parse_snippet('if', 'if $1 then\n  $0\nend'),
  ls.parser.parse_snippet('then', 'then\n  $0\nend'),
  ls.parser.parse_snippet('pr', 'print($1)$0'),
  ls.parser.parse_snippet('in', 'vim.inspect($1)$0'),
  ls.parser.parse_snippet('prin', 'print(vim.inspect($1))$0'),
  ls.parser.parse_snippet('desc', "describe('$1', function()\n  $0\nend)"),
  ls.parser.parse_snippet('it', "it('$1', function()\n  $0\nend)"),
  s(
    'req',
    fmt('local {} = {}', {
      i(1),
      c(2, {
        ps(nil, "require '$1'"),
        ps(nil, "require('$1').$2"),
      }),
    })
  ),
}, {
  key = 'lua',
})

ls.add_snippets('go', {
  s(
    'func',
    fmt('func{}{}({}) {}{}{{\n\t{}\n}}', { nonempty(1, ' ', ''), i(1), i(2), i(3), nonempty(3, ' ', ''), i(0) })
  ),
  s('mfunc', fmt('func ({}) {}({}) {}{}{{\n\t{}\n}}', { i(1), i(2), i(3), i(4), nonempty(4, ' ', ''), i(0) })),
  ls.parser.parse_snippet('if', 'if $1 {\n\t$0\n}'),
  s(
    {
      trig = 'iferr',
      docstring = strings.dedent [[
        if (err != nil || err := f(); err != nil) {

        }]],
    },
    fmt('if {} {{\n\t{}\n}}', {
      c(1, {
        fmt('{} != nil', { i(1, 'err') }),
        fmt('{} := {}; {} != nil', { i(1, 'err'), i(2), rep(1) }),
      }),
      i(0),
    })
  ),
  s(
    'for',
    fmt(
      'for {} := range {} {{\n\t{}\n}}',
      { c(1, { { t '_, ', i(1, 'v') }, { i(1, 'i'), t ', ', i(2, 'v') }, i(nil, 'i') }), i(2), i(0) }
    )
  ),
  ls.parser.parse_snippet('fori', 'for ${1:i} := ${2:0}; $1 < $3; $1++ {\n\t$0\n}'),
  ls.parser.parse_snippet('pr', 'fmt.Println($1)$0'),
  ls.parser.parse_snippet('prf', 'fmt.Printf("$1\\n", $2)$0'),
  s(
    {
      trig = 'slice',
      docstring = '[]$1{$2} || make([]$1, $2)',
    },
    c(1, {
      ls.parser.parse_snippet(nil, '[]$1{$2}'),
      ls.parser.parse_snippet(nil, 'make([]$1, $2)'),
    })
  ),
  s(
    {
      trig = 'map',
      docstring = 'map[$1]$2{$3} || make(map[$1]$2, $3)',
    },
    c(1, {
      ls.parser.parse_snippet(nil, 'map[$1]$2{$3}'),
      ls.parser.parse_snippet(nil, 'make(map[$1]$2, $3)'),
    })
  ),
  ls.parser.parse_snippet('append', '$1 = append($1, $2)'),
}, {
  key = 'go',
})
