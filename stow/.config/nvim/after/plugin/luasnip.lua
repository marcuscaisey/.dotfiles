local ok, luasnip = pcall(require, 'luasnip')
if not ok then
  return
end

luasnip.add_snippets('go', {
  luasnip.parser.parse_snippet('dp', 'fmt.Printf("$1: %+v\\n", $1)'),
  luasnip.parser.parse_snippet(
    'jp',
    [[
      $1Bytes, err := json.MarshalIndent($1, "", "  ")
      if err != nil {{
          panic(err)
      }}
      fmt.Printf("$1: %+v\n", string($1Bytes))
  ]]
  ),
}, {
  key = 'go',
})

vim.keymap.set('n', '<leader><leader>s', function()
  vim.cmd.source('~/.dotfiles/stow/.config/nvim/after/plugin/luasnip.lua')
  print('Reloaded snippets')
end)
