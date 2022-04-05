local ls = require 'luasnip'

ls.config.setup {
  updateevents = 'TextChanged,TextChangedI',
}

ls.add_snippets('lua', {
  ls.parser.parse_snippet('func', 'function ${1:name}($2)\n  $0\nend'),
  ls.parser.parse_snippet('lfunc', 'local ${1:name} = function($2)\n  $0\nend'),
  ls.parser.parse_snippet('mfunc', '${1:M}.${2:name} = function($3)\n  $0\nend'),
  ls.parser.parse_snippet('for', 'for ${1:k}, ${2:v} in pairs(${3:t}) do\n  $0\nend'),
  ls.parser.parse_snippet('fori', 'for ${1:_}, ${2:v} in ipairs(${3:t}) do\n  $0\nend'),
  ls.parser.parse_snippet('p', 'print($1)$0'),
  ls.parser.parse_snippet('i', 'vim.inspect($1)$0'),
  ls.parser.parse_snippet('pi', 'print(vim.inspect($1))$0'),
}, { key = 'lua' })
