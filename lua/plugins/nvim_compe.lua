local o = vim.o

o.completeopt = "menuone,noselect"
o.shortmess = o.shortmess .. 'c'

require('compe').setup {
  source = {
    nvim_lsp = true,
  },
}

