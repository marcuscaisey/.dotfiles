local leap = require 'leap'

leap.setup {
  case_insensitive = true,
  labels = { ... },
}
leap.set_default_keymaps()
