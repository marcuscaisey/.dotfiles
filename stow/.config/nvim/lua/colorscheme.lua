local ok, catppuccin = pcall(require, 'catppuccin')
if not ok then
  return
end
local colors = require('catppuccin.utils.colors')

---@diagnostic disable-next-line: missing-fields
catppuccin.setup({
  auto_integrations = true,
  integrations = {
    ---@diagnostic disable-next-line: missing-fields
    native_lsp = {
      underlines = {
        errors = { 'undercurl' },
        hints = { 'undercurl' },
        warnings = { 'undercurl' },
        information = { 'undercurl' },
      },
    },
  },
  color_overrides = {
    mocha = {
      base = '#000000',
      mantle = '#010101',
      crust = '#020202',
    },
  },
  highlight_overrides = {
    mocha = function(palette)
      return {
        DiffChange = { bg = colors.darken(palette.blue, 0.15, palette.base) },
        IncSearch = { bg = palette.peach },
      }
    end,
  },
  custom_highlights = {
    CurSearch = { link = 'IncSearch' },
    TelescopeSelection = { link = 'Visual' },
  },
  flavour = 'mocha',
})

for _, kind in ipairs(vim.lsp.protocol.CompletionItemKind) do
  vim.api.nvim_set_hl(0, 'LspItemKind' .. kind, { link = 'BlinkCmpKind' .. kind })
end

vim.cmd.colorscheme('catppuccin')
