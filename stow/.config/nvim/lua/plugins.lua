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
    if spec.name == 'nvim-treesitter' then
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
  { src = 'https://github.com/ibhagwan/fzf-lua' },
  { src = 'https://github.com/inkarkat/vim-ingo-library' }, -- Required for vim-CountJump
  { src = 'https://github.com/inkarkat/vim-ConflictMotions' }, -- Required for vim-ConflictMotions
  { src = 'https://github.com/inkarkat/vim-CountJump' }, -- Required for vim-ConflictMotions
  { src = 'https://github.com/jake-stewart/multicursor.nvim' },
  { src = 'https://github.com/kana/vim-textobj-entire' },
  { src = 'https://github.com/kana/vim-textobj-user' }, -- Required for vim-textobj-entire
  { src = 'https://github.com/kosayoda/nvim-lightbulb' },
  { src = 'https://github.com/kyazdani42/nvim-web-devicons' },
  { src = 'https://github.com/kylechui/nvim-surround' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  { src = 'https://github.com/marcuscaisey/olddirs.nvim' },
  { src = 'https://github.com/marcuscaisey/please.nvim' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/michaeljsmith/vim-indent-object' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/tpope/vim-fugitive' },
  { src = 'https://github.com/vim-scripts/ReplaceWithRegister' },
})
-- Set so that ReplaceWithRegister doesn't create default mappings before we can override them in
-- after/plugin/replacewithregister.lua
vim.g.loaded_ReplaceWithRegister = true

vim.cmd.packadd('nvim.undotree')

vim.api.nvim_create_user_command('PackUpdate', function(args)
  vim.pack.update(#args.fargs > 0 and args.fargs or nil)
end, { nargs = '*', complete = 'packadd', desc = 'Update the given plugins' })
vim.api.nvim_create_user_command('PackSync', function(args)
  vim.pack.update(#args.fargs > 0 and args.fargs or nil, { target = 'lockfile' })
end, { nargs = '*', complete = 'packadd', desc = 'Sync the versions of the given plugins with the lockfile' })
vim.api.nvim_create_user_command('PackDelete', function(args)
  vim.pack.del(args.fargs)
end, { nargs = '+', complete = 'packadd', desc = 'Delete the given plugins' })
