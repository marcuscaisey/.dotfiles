local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system { 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd 'packadd packer.nvim'
end

require('packer').startup {
  function(use)
    use 'wbthomason/packer.nvim'

    -- Syntax
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require 'plugins.treesitter'
      end,
      requires = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        'romgrk/nvim-treesitter-context',
      },
    }

    -- Completion
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
      requires = {
        'hrsh7th/vim-vsnip',
        'hrsh7th/cmp-vsnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'hrsh7th/cmp-buffer',
        'onsails/lspkind-nvim',
      },
    }
    use {
      'ray-x/lsp_signature.nvim',
      config = function()
        require 'plugins.lsp_signature'
      end,
    }

    -- UI
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

    -- Command
    use {
      'nvim-telescope/telescope.nvim',
      config = function()
        require 'plugins.telescope'
      end,
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
        },
      },
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
      'ggandor/lightspeed.nvim',
      config = function()
        require 'plugins.lightspeed'
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
    use 'nvim-treesitter/playground'
    use {
      'marcuscaisey/please.nvim',
      branch = 'jump-to-target',
    }

    -- Text objects
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
