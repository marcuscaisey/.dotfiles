local ls = require('luasnip')
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local ps = ls.parser.parse_snippet
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep
local nonempty = require('luasnip.extras').nonempty
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
  ls.parser.parse_snippet('ppr', 'vim.print($0)'),
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
  ls.parser.parse_snippet('fe', 'fmt.Errorf("$1: ${2:%w}"$3, err)$0'),
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
  s('f', {
    d(1, function()
      if not vim.treesitter.get_node():parent() then
        -- Named function if we're at the top level of the file
        return sn(nil, fmt('func {}({}) {}{}{{\n\t{}\n}}', { i(1), i(2), i(3), nonempty(4, ' ', ''), i(0) }))
      else
        -- Anonymous function if we're not at the top level of the file
        return sn(nil, fmt('func({}) {}{}{{\n\t{}\n}}', { i(1), i(2), nonempty(3, ' ', ''), i(0) }))
      end
    end),
  }),
  s(
    'mf',
    fmt('func ({}) {}({}) {}{}{{\n\t{}\n}}', {
      i(1),
      i(2),
      i(3),
      i(4),
      nonempty(4, ' ', ''),
      i(0),
    })
  ),
  ls.parser.parse_snippet('gf', 'go func($1) {\n\t$2\n}($3)$0'),
}, {
  key = 'go',
})

ls.add_snippets('gitrebase', {
  ps('up', 'update-ref refs/heads/$0'),
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
