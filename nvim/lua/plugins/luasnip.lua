local ls = require 'luasnip'
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require('luasnip.extras.fmt').fmt
local nonempty = require('luasnip.extras').nonempty

ls.config.setup {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
}

ls.add_snippets('lua', {
  s('func', fmt('function{}{}({})\n  {}\nend{}', { nonempty(1, ' ', ''), i(1), i(2), i(3), i(0) })),
  ls.parser.parse_snippet('lfunc', 'local $1 = function($2)\n  $0\nend'),
  ls.parser.parse_snippet('mfunc', '$1.$2 = function($3)\n  $0\nend'),
  ls.parser.parse_snippet('for', 'for $1, $2 in pairs($3) do\n  $0\nend'),
  ls.parser.parse_snippet('fori', 'for $1, $2 in ipairs($3) do\n  $0\nend'),
  ls.parser.parse_snippet('if', 'if $1 then\n  $0\nend'),
  ls.parser.parse_snippet('then', 'then\n  $0\nend'),
  ls.parser.parse_snippet('pr', 'print($1)$0'),
  ls.parser.parse_snippet('in', 'vim.inspect($1)$0'),
  ls.parser.parse_snippet('prin', 'print(vim.inspect($1))$0'),
  -- ls.parser.parse_snippet('req', "local $1 = require '$2'$0"),
  s(
    'req',
    fmt("local {} = require '{}'{}", {
      f(function(args)
        local parts = vim.split(args[1][1], '.', true)
        return parts[#parts] or ''
      end, {
        1,
      }),
      i(1),
      i(0),
    })
  ),
}, {
  key = 'lua',
})

ls.add_snippets('go', {
  s('func', fmt('func {}({}) {}{}{{\n\t{}\n}}', { i(1, 'name'), i(2), i(3), nonempty(3, ' ', ''), i(0) })),
}, {
  key = 'go',
})
