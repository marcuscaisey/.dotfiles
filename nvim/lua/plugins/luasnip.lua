local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt
local nonempty = require('luasnip.extras').nonempty

ls.config.setup {
  updateevents = 'TextChanged,TextChangedI',
}

ls.add_snippets('lua', {
  s('func', fmt('function{}{}({})\n  {}\nend', { nonempty(1, ' ', ''), i(1), i(2), i(0) })),
  ls.parser.parse_snippet('lfunc', 'local ${1:name} = function($2)\n  $0\nend'),
  ls.parser.parse_snippet('mfunc', '${1:M}.${2:name} = function($3)\n  $0\nend'),
  ls.parser.parse_snippet('for', 'for ${1:k}, ${2:v} in pairs(${3:t}) do\n  $0\nend'),
  ls.parser.parse_snippet('fori', 'for ${1:_}, ${2:v} in ipairs(${3:t}) do\n  $0\nend'),
  ls.parser.parse_snippet('if', 'if $1 then\n  $0\nend'),
  ls.parser.parse_snippet('then', 'then\n  $0\nend'),
  ls.parser.parse_snippet('pr', 'print($1)$0'),
  ls.parser.parse_snippet('in', 'vim.inspect($1)$0'),
  ls.parser.parse_snippet('pin', 'print(vim.inspect($1))$0'),
  ls.parser.parse_snippet('req', "local $1 = require '$2'$0"),
}, { key = 'lua' })
