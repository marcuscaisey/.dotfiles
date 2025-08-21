local post_install_cmds = {
  ['blink.cmp'] = 'cargo build --release',
  ['nvim-treesitter'] = ':TSUpdate',
  ['telescope-fzf-native.nvim'] = 'make',
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
        vim.notify('Running ' .. name .. ' post-install command: ' .. cmd, vim.log.levels.INFO)
        local ok = false
        local err = '' ---@type string?
        if vim.startswith(cmd, ':') then
          ---@diagnostic disable-next-line: param-type-mismatch
          ok, err = pcall(vim.cmd, cmd)
        else
          local obj = vim.system(vim.split(cmd, ' '), { cwd = args.data.path }):wait()
          ok = obj.code == 0
          err = obj.stderr
        end
        if ok then
          vim.notify(name .. ' post-install command successful', vim.log.levels.INFO)
        else
          vim.notify(name .. ' post-install command failed: ' .. err, vim.log.levels.ERROR)
        end
      end
    end
  end,
})

vim.pack.add({
  { src = 'https://github.com/bkad/camelcasemotion' },
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  { src = 'https://github.com/jake-stewart/multicursor.nvim' },
  { src = 'https://github.com/kosayoda/nvim-lightbulb' },
  { src = 'https://github.com/kyazdani42/nvim-web-devicons' },
  { src = 'https://github.com/kylechui/nvim-surround' },
  -- Pin version until https://github.com/lewis6991/gitsigns.nvim/issues/1381 is fixed.
  { src = 'https://github.com/lewis6991/gitsigns.nvim', version = '60676707b6a5fa42369e8ff40a481ca45987e0d0' },
  { src = 'https://github.com/marcuscaisey/lox', data = { rtp = 'tree-sitter-lox' } },
  { src = 'https://github.com/marcuscaisey/olddirs.nvim' },
  { src = 'https://github.com/marcuscaisey/please.nvim' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' }, -- Required for telescope.nvim
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
  { src = 'https://github.com/saghen/blink.cmp' },
  { src = 'https://github.com/stevearc/dressing.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/tpope/vim-fugitive' },
  { src = 'https://github.com/vim-scripts/ReplaceWithRegister', data = { opt = true } },
}, {
  load = function(plug_data)
    plug_data.spec.data = plug_data.spec.data or {}
    local data = plug_data.spec.data or {}
    if not data.opt then
      vim.cmd('packadd! ' .. plug_data.spec.name)
    end
    if data.rtp then
      vim.opt.runtimepath:append(vim.fs.joinpath(plug_data.path, data.rtp))
    end
  end,
})
