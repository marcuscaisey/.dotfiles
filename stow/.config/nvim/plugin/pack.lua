local post_install_cmds = {
  ['blink.cmp'] = { 'cargo', 'build', '--release' },
  ['telescope-fzf-native.nvim'] = { 'make' },
}

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack_post_install_commands', {}),
  desc = 'Run post installation commands',
  ---@param args {data:{kind:'install'|'update'|'delete', spec:vim.pack.SpecResolved, path:string}}
  callback = function(args)
    if args.data.kind ~= 'update' then
      return
    end
    for name, cmd in pairs(post_install_cmds) do
      if args.data.spec.name == name then
        vim.notify('Building ' .. name, vim.log.levels.INFO)
        local obj = vim.system(cmd, { cwd = args.data.path }):wait()
        if obj.code == 0 then
          vim.notify('Building ' .. name .. ' done', vim.log.levels.INFO)
        else
          vim.notify('Building ' .. name .. ' failed', vim.log.levels.ERROR)
        end
      end
    end
  end,
})

vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/kosayoda/nvim-lightbulb',
  'https://github.com/saghen/blink.cmp',
  'https://github.com/kyazdani42/nvim-web-devicons',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/stevearc/dressing.nvim',
  { src = 'https://github.com/catppuccin/nvim', version = '82f3dcedc9acc242d2d4f98abca02e2f10a75248', name = 'catppuccin' },
  'https://github.com/nvim-lua/plenary.nvim', -- Required for telescope.nvim
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/bkad/camelcasemotion',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/marcuscaisey/please.nvim',
  'https://github.com/marcuscaisey/olddirs.nvim',
  'https://github.com/marcuscaisey/lox',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/jake-stewart/multicursor.nvim',
})
vim.pack.add({
  'https://github.com/vim-scripts/ReplaceWithRegister',
}, { load = false })

for _, plugin in ipairs(vim.pack.get()) do
  if plugin.spec.name == 'lox' then
    vim.opt.runtimepath:append(vim.fs.joinpath(plugin.path, 'tree-sitter-lox'))
  end
end
