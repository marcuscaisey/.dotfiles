local ok, oil = pcall(require, 'oil')
if not ok then
  return
end
local ok, telescope_builtin = pcall(require, 'telescope.builtin')
if not ok then
  return
end

oil.setup({
  use_default_keymaps = false,
  keymaps = {
    ['g?'] = 'actions.show_help',
    ['<cr>'] = 'actions.select',
    ['<c-s>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
    ['<c-h>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
    ['gp'] = 'actions.preview',
    ['<c-p>'] = {
      function()
        local dir = oil.get_current_dir()
        if not dir then
          return
        end
        telescope_builtin.find_files({
          prompt_title = 'Find files in ' .. dir:gsub('^' .. os.getenv('HOME'), '~'),
          cwd = dir,
        })
      end,
      mode = 'n',
      nowait = true,
      desc = 'Find files in the current directory',
    },
    ['<c-g>'] = {
      function()
        local dir = oil.get_current_dir()
        if not dir then
          return
        end
        telescope_builtin.live_grep({
          prompt_title = 'Live Grep in ' .. dir:gsub('^' .. os.getenv('HOME'), '~'),
          search_dirs = { dir },
        })
      end,
      desc = 'telescope.builtin.live_grep({ search_dirs = { oil.get_current_dir() } })',
    },
    ['<c-l>'] = 'actions.refresh',
    ['-'] = 'actions.parent',
    ['_'] = 'actions.open_cwd',
    ['`'] = 'actions.cd',
    ['~'] = { 'actions.cd', opts = { scope = 'win' }, desc = ':lcd to the current oil directory' },
    ['gs'] = 'actions.change_sort',
    ['g.'] = 'actions.toggle_hidden',
  },
})

vim.keymap.set('n', '-', oil.open, { desc = 'oil.open()' })