local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local ps = ls.parser.parse_snippet
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep
local nonempty = require('luasnip.extras').nonempty
local strings = require('plenary.strings')
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

ls.add_snippets('lua', {
  ls.parser.parse_snippet('f', 'function($1)\n  $0\nend'),
  ls.parser.parse_snippet('lf', 'local ${1:name} = function($2)\n  $0\nend'),
  ls.parser.parse_snippet('mf', '${1:M}.${2:name} = function($3)\n  $0\nend'),
  ls.parser.parse_snippet('if', 'if $1 then\n  $0\nend'),
  ls.parser.parse_snippet('pr', 'print($0)'),
  ls.parser.parse_snippet('ppr', 'vim.pretty_print($0)'),
  ls.parser.parse_snippet('in', 'vim.inspect($0)'),
  ls.parser.parse_snippet('for', 'for ${1:k}, ${2:v} in ${3|pairs,ipairs|}(${4:t}) do \n  $0\nend'),
  ls.parser.parse_snippet('desc', 'describe($1, function()\n  $0\nend)'),
  ls.parser.parse_snippet('it', 'it($1, function()\n  $0\nend)'),
  ls.parser.parse_snippet('req', "local $1 = require '$2'"),
}, {
  key = 'lua',
})

ls.add_snippets('go', {
  ls.parser.parse_snippet('prf', 'fmt.Printf("$1\\n", $0)'),
  ls.parser.parse_snippet('pr', 'fmt.Println($0)'),
  s(
    'iferr',
    fmt('if {} {{\n\t{}\n}}', {
      c(1, {
        fmt('{} != nil', { i(1, 'err') }),
        fmt('{} := {}; {} != nil', { i(1, 'err'), i(2), rep(1) }),
      }),
      i(0),
    })
  ),
  ls.parser.parse_snippet('if', 'if $1 {\n\t$0\n}'),
  s(
    'for',
    fmt('for {} := range {} {{\n\t{}\n}}', {
      c(1, {
        { i(1, '_'), t(', '), i(2, nil) },
        i(nil, nil),
      }),
      i(2),
      i(0),
    })
  ),
  ls.parser.parse_snippet('fori', 'for ${1:i} := 0; $1 < $3; $1++ {\n\t$0\n}'),
  ls.parser.parse_snippet('f', 'func ${1}($2) $3 {\n\t$0\n}'),
  ls.parser.parse_snippet('mf', 'func ($1) $2($3) $4 {\n\t$0\n}'),
  ls.parser.parse_snippet('gf', 'go func($1) {\n\t$2\n}($3)$0'),
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