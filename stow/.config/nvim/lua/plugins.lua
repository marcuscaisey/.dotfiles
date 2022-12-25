local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
  vim.cmd.packadd('packer.nvim')
end

require('packer').startup({
  function(use)
    use('wbthomason/packer.nvim')
    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
    })
    use('nvim-treesitter/nvim-treesitter-textobjects')
    use('lewis6991/nvim-treesitter-context')
    use('nvim-treesitter/playground')
    use('windwp/nvim-ts-autotag')
    use('neovim/nvim-lspconfig')
    use({
      'kosayoda/nvim-lightbulb',
      requires = 'antoinemadec/FixCursorHold.nvim',
      config = function()
        require('nvim-lightbulb').setup({ autocmd = { enabled = true } })
      end,
    })
    use('hrsh7th/nvim-cmp')
    use('saadparwaiz1/cmp_luasnip')
    use('hrsh7th/cmp-nvim-lsp')
    use('hrsh7th/cmp-nvim-lua')
    use('hrsh7th/cmp-buffer')
    use('hrsh7th/cmp-path')
    use('mfussenegger/nvim-dap')
    use({
      'theHamsta/nvim-dap-virtual-text',
      config = function()
        require('nvim-dap-virtual-text').setup({})
      end,
    })
    use('rcarriga/nvim-dap-ui')
    use('L3MON4D3/LuaSnip')
    use('ray-x/lsp_signature.nvim')
    use({
      'nvim-lualine/lualine.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
    })
    use({
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
    })
    use('stevearc/dressing.nvim')
    use('catppuccin/nvim')
    use({
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end,
    })
    use({
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
      },
    })
    use({
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
    })
    use('tpope/vim-eunuch')
    use('tpope/vim-repeat')
    use({
      'windwp/nvim-autopairs',
      config = function()
        require('nvim-autopairs').setup()
      end,
    })
    use('vim-scripts/ReplaceWithRegister')
    use('tpope/vim-commentary')
    use('tpope/vim-surround')
    use('ggandor/leap.nvim')
    use('bkad/camelcasemotion')
    use('ojroques/vim-oscyank')
    use('sbdchd/neoformat')
    use('svban/YankAssassin.vim')
    use('tpope/vim-fugitive')
    use('tpope/vim-unimpaired')
    use({
      'ThePrimeagen/harpoon',
      requires = 'nvim-lua/plenary.nvim',
    })
    use('tpope/vim-vinegar')
    use('marcuscaisey/please.nvim')
    use({
      'kana/vim-textobj-entire',
      requires = 'kana/vim-textobj-user',
    })
    use('nelstrom/vim-visual-star-search')
    use('michaeljsmith/vim-indent-object')
    use('tpope/vim-abolish')
    use({
      'akinsho/git-conflict.nvim',
      tag = '*',
    })
    use({
      'https://gitlab.com/yorickpeterse/nvim-pqf',
      config = function()
        require('pqf').setup()
      end,
    })
    use('AndrewRadev/splitjoin.vim')
    use('smjonas/live-command.nvim')
    use('prichrd/netrw.nvim')
  end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    },
  },
})
