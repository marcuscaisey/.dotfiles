local ok, copilot = pcall(require, 'copilot')
if not ok then
  return
end
local suggestion = require('copilot.suggestion')

if vim.env.NVIM_DISABLE_COPILOT ~= 'true' then
  copilot.setup({
    suggestion = {
      auto_trigger = true,
      hide_during_completion = false,
      keymap = {
        accept = '<C-L>',
        dismiss = '<C-K>',
      },
    },
    filetype = {
      markdown = true,
    },
    copilot_model = 'gpt-4o-copilot',
  })
end

vim.keymap.set('n', '<Leader>cc', suggestion.toggle_auto_trigger, { desc = 'copilot.suggestion.toggle_auto_trigger()' })
