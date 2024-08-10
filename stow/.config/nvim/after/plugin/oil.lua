local ok, oil = pcall(require, 'oil')
if not ok then
  return
end
local ok, telescope_builtin = pcall(require, 'telescope.builtin')
if not ok then
  return
end

oil.setup()

vim.keymap.set('n', '-', oil.open, { desc = 'oil.open()' })

local augroup = vim.api.nvim_create_augroup('oil', { clear = true })

vim.api.nvim_create_autocmd('BufEnter', {
  group = augroup,
  pattern = { 'oil:///*' },
  desc = 'Add oil specific mappings',
  callback = function(args)
    vim.keymap.set('n', '<c-f>', function()
      vim.cmd.lcd(oil.get_current_dir(args.buf))
      oil.close()
    end, { buffer = args.buf, desc = ':lcd oil.get_current_dir()' })
    vim.keymap.set('n', '<c-g>', function()
      local dir = oil.get_current_dir(args.buf)
      if not dir then
        return
      end
      telescope_builtin.live_grep({
        prompt_title = 'Live Grep in ' .. dir:gsub('^' .. os.getenv('HOME'), '~'),
        search_dirs = { dir },
      })
    end, { buffer = args.buf, desc = 'telescope.builtin.live_grep({ search_dirs = { oil.get_current_dir() } })' })
  end,
})
