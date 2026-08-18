vim.keymap.set(
    'n',
    '<Leader>/',
    [[/^\s*\(\s\|$\)<Left><Left><Left><Left><Left><Left><Left><Left><Left>]],
    { buf = 0, desc = 'Search forwards for a word which starts a line' }
)
