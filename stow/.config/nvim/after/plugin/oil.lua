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
    ['<CR>'] = 'actions.select',
    ['<C-S>'] = { 'actions.select', opts = { vertical = true }, desc = 'Open the entry in a vertical split' },
    ['<C-H>'] = { 'actions.select', opts = { horizontal = true }, desc = 'Open the entry in a horizontal split' },
    ['gp'] = 'actions.preview',
    ['<C-P>'] = {
      function()
        local dir = oil.get_current_dir()
        if not dir then
          return
        end
        if vim.env.HOME then
          dir = dir:gsub('^' .. vim.pesc(vim.env.HOME), '~')
        end
        telescope_builtin.find_files({
          prompt_title = 'Find files in ' .. dir,
          find_command = { 'fd', '--strip-cwd-prefix', '--follow', '--hidden', '--exclude', '.git' },
          cwd = dir,
        })
      end,
      mode = 'n',
      nowait = true,
      desc = 'Find files in the current directory',
    },
    ['<C-G>'] = {
      function()
        local dir = oil.get_current_dir()
        if not dir then
          return
        end
        if vim.env.HOME then
          dir = dir:gsub('^' .. vim.pesc(vim.env.HOME), '~')
        end
        telescope_builtin.live_grep({
          prompt_title = 'Live Grep in ' .. dir,
          search_dirs = { dir },
        })
      end,
      desc = 'Grep over files in the current directory',
    },
    ['<C-L>'] = 'actions.refresh',
    ['-'] = 'actions.parent',
    ['_'] = 'actions.open_cwd',
    ['`'] = 'actions.cd',
    ['~'] = { 'actions.cd', opts = { scope = 'win' }, desc = ':lcd to the current oil directory' },
    ['gs'] = 'actions.change_sort',
    ['g.'] = 'actions.toggle_hidden',
  },
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
  },
})

vim.keymap.set('n', '-', oil.open, { desc = 'oil.open()' })
