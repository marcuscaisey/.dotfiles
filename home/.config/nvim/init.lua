require('my.options') -- Load first so anything below sees the correct options
require('my.plugins') -- Load next so plugins are available to everything below
require('my.colorscheme')
require('my.dir')
require('my.keymaps')
require('my.lsp')
require('my.misc')
require('my.statusline')
