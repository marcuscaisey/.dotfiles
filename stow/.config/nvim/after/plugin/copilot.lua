local fn = vim.fn

vim.g.copilot_filetypes = {
  markdown = true,
}

vim.g.copilot_enabled = false

local function start_copilot()
  vim.cmd.packadd('copilot.vim')
  vim.keymap.set('i', '<C-E>', 'pumvisible() ? "<C-E>" : "<Plug>(copilot-dismiss)"', {
    expr = true,
    replace_keycodes = false,
  })
  -- Force copilot to attach to the current buffer
  vim.cmd.write()
  vim.cmd.edit()
end

vim.keymap.set('n', '<Leader>cc', function()
  if vim.g.copilot_enabled then
    print('Disabled copilot')
    vim.g.copilot_enabled = false
  else
    if fn.exists(':Copilot') ~= 2 then
      start_copilot()
      print('Started copilot')
    else
      print('Enabled copilot')
    end
    vim.g.copilot_enabled = true
  end
end, { desc = 'Toggle copilot' })
