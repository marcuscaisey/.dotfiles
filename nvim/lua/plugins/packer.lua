local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system { 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd 'packadd packer.nvim'
end

require('packer').startup {
  function(use)
    use 'wbthomason/packer.nvim'
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require 'plugins.treesitter'
      end,
    }
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'romgrk/nvim-treesitter-context'
    use 'nvim-treesitter/playground'
    use {
      'neovim/nvim-lspconfig',
      config = function()
        require 'plugins.lspconfig'
      end,
    }
    use {
      'hrsh7th/nvim-cmp',
      config = function()
        require 'plugins.cmp'
      end,
    }
    use 'saadparwaiz1/cmp_luasnip'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-nvim-lua'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-nvim-lsp-signature-help'
    use {
      'L3MON4D3/LuaSnip',
      config = function()
        require 'plugins.luasnip'
      end,
    }
    use {
      'NTBBloodbath/galaxyline.nvim',
      config = function()
        require 'plugins.galaxyline'
      end,
      requires = 'kyazdani42/nvim-web-devicons',
    }
    use {
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require 'plugins.gitsigns'
      end,
    }
    use 'stevearc/dressing.nvim'
    use 'ellisonleao/gruvbox.nvim'
    use {
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end,
    }
    use {
      'nvim-telescope/telescope.nvim',
      config = function()
        require 'plugins.telescope'
      end,
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
      },
    }
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
    }
    use 'tpope/vim-eunuch'
    use 'tpope/vim-repeat'
    use {
      'windwp/nvim-autopairs',
      config = function()
        require('nvim-autopairs').setup()
      end,
    }
    use 'vim-scripts/ReplaceWithRegister'
    use {
      'tpope/vim-commentary',
      config = function()
        require 'plugins.commentary'
      end,
    }
    use 'tpope/vim-surround'
    use {
      'ggandor/leap.nvim',
      config = function()
        require 'plugins.leap'
      end,
    }
    use {
      'bkad/camelcasemotion',
      config = function()
        require 'plugins.camelcasemotion'
      end,
    }
    use {
      'ojroques/vim-oscyank',
      config = function()
        require 'plugins.oscyank'
      end,
    }
    use {
      'sbdchd/neoformat',
      config = function()
        require 'plugins.neoformat'
      end,
    }
    use 'svban/YankAssassin.vim'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-unimpaired'
    use {
      'ThePrimeagen/harpoon',
      config = function()
        require 'plugins.harpoon'
      end,
      requires = 'nvim-lua/plenary.nvim',
    }
    use {
      'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      config = function()
        require 'plugins.neo_tree'
      end,
      requires = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
      },
    }
    use '~/scratch/please.nvim'
    use {
      'kana/vim-textobj-entire',
      requires = 'kana/vim-textobj-user',
    }
  end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    },
  },
}
