local ok, catppuccin = pcall(require, 'catppuccin')
if not ok then
  return
end
local colors = require('catppuccin.utils.colors')

catppuccin.setup({
  flavour = 'mocha',
  color_overrides = {
    mocha = {
      base = '#000000',
    },
  },
  highlight_overrides = {
    mocha = function(palette)
      return {
        NormalFloat = { fg = palette.overlay2, bg = palette.surface0 },
        DiffChange = { bg = colors.darken(palette.blue, 0.15, palette.base) },
      }
    end,
  },
  integrations = {
    copilot_vim = true,
  },
})

for _, kind in ipairs(vim.lsp.protocol.CompletionItemKind) do
  vim.api.nvim_set_hl(0, string.format('LspItemKind%s', kind), { link = string.format('CmpItemKind%s', kind) })
end

vim.cmd.colorscheme('catppuccin')
