local ls = require 'luasnip'

ls.config.setup {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
}
