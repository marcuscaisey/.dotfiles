local fm = require('fm-nvim')

fm.setup({
  ui = {
    float = {
      border = 'single',
      height = 0.95,
      width = 0.95,
    },
  },
  mappings = {
    horz_split = '<c-x>',
  },
})

vim.keymap.set('n', '<c-f>', function()
  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  fm.Vifm(dir)
end)
