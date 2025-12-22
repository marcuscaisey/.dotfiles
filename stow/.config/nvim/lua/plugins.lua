vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack_post_install_commands', {}),
  desc = 'Run post installation commands',
  ---@class PackChangedCallbackArgs : vim.api.keyset.create_autocmd.callback_args
  ---@field data {active:boolean, kind:'install'|'update'|'delete', spec:vim.pack.Spec, path:string}
  ---@param args PackChangedCallbackArgs
  callback = function(args)
    local active, kind, spec, path = args.data.active, args.data.kind, args.data.spec, args.data.path
    if not (kind == 'update' or kind == 'install') then
      return
    end
    if spec.name == 'telescope-fzf-native.nvim' then
      local out = vim.system({ 'make' }, { cwd = path }):wait()
      assert(out.code == 0, out.stderr)
    elseif spec.name == 'nvim-treesitter' then
      if not active then
        vim.cmd.packadd('nvim-treesitter')
      end
      vim.cmd.TSUpdate()
    elseif spec.name == 'blink.cmp' then
      local out = vim.system({ 'cargo', 'build', '--release' }, { cwd = path }):wait()
      assert(out.code == 0, out.stderr)
    end
  end,
})

vim.pack.add({
  { src = 'https://github.com/bkad/camelcasemotion' },
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  { src = 'https://github.com/jake-stewart/multicursor.nvim' },
  { src = 'https://github.com/kana/vim-textobj-entire' },
  { src = 'https://github.com/kana/vim-textobj-user' }, -- Required for vim-textobj-entire
  { src = 'https://github.com/kosayoda/nvim-lightbulb' },
  { src = 'https://github.com/kyazdani42/nvim-web-devicons' },
  { src = 'https://github.com/kylechui/nvim-surround' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/marcuscaisey/lox' },
  { src = 'https://github.com/marcuscaisey/olddirs.nvim' },
  { src = 'https://github.com/marcuscaisey/please.nvim' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/michaeljsmith/vim-indent-object' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' }, -- Required for telescope.nvim
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/stevearc/dressing.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/tpope/vim-fugitive' },
})

vim.pack.add({
  { src = 'https://github.com/vim-scripts/ReplaceWithRegister' },
}, { load = false })

vim.cmd.packadd('nvim.undotree')
