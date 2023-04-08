vim.g.projectionist_heuristics = {
  ['*'] = {
    ['*_test.py'] = { alternate = '{}.py' },
    ['*.py'] = { alternate = '{}_test.py' },
    ['*_test.go'] = { alternate = '{}.go' },
    ['*.go'] = { alternate = '{}_test.go' },
  },
  ['lua/'] = {
    ['lua/*.lua'] = { alternate = 'tests/{}_spec.lua' },
    ['tests/*_spec.lua'] = { alternate = 'lua/{}.lua' },
  },
}

vim.keymap.set('n', '<leader>a', vim.cmd.A)
