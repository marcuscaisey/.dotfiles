local ok, oil = pcall(require, 'oil')
if not ok then
  return
end
local ok, fzf = pcall(require, 'fzf-lua')
if not ok then
  return
end

oil.setup({
  keymaps = {
    ['gp'] = 'actions.preview',
    ['<C-p>'] = {
      function()
        fzf.files({
          fd_opts = fzf.defaults.files.fd_opts .. ' --type d --strip-cwd-prefix',
          cwd = oil.get_current_dir(),
        })
      end,
      desc = 'Find files in the current directory',
    },
    ['<C-G>'] = {
      function()
        fzf.live_grep({ cwd = oil.get_current_dir() })
      end,
      desc = 'Grep over files in the current directory',
    },
    ['_'] = 'actions.open_cwd',
    ['+'] = {
      desc = "Open oil in the git repository root",
      callback = function()
        local root = vim.fs.root(oil.get_current_dir() or '', '.git')
        if not root then
          return
        end
        oil.open(root)
      end,
    },
    ['~'] = { 'actions.cd', opts = { scope = 'win' }, desc = ':lcd to the current oil directory' },
  },
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
  },
})

vim.keymap.set('n', '-', oil.open, { desc = 'oil.open()' })
