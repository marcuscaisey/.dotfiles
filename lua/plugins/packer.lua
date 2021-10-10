local g = vim.g
local fn = vim.fn
local cmd = vim.cmd
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local execute = vim.api.nvim_command

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

cmd('autocmd BufWritePost packer.lua source <afile> | PackerCompile')

require('packer').startup({
  function(use)
    use 'wbthomason/packer.nvim'

    -- Syntax
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = [[ require 'plugins.nvim_treesitter' ]],
    }

    -- Completion
    use {
      'neovim/nvim-lspconfig',
      config = [[ require 'plugins.nvim_lspconfig' ]],
    }
    use {
      'hrsh7th/nvim-cmp',
      config = [[ require 'plugins.nvim_cmp' ]],
    }
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/cmp-vsnip'

    -- UI
    use {
      'NTBBloodbath/galaxyline.nvim',
      config = [[ require 'plugins.galaxyline' ]],
      requires = 'kyazdani42/nvim-web-devicons',
    }
    use {
      'airblade/vim-gitgutter',
      config = [[ require 'plugins.vim_gitgutter' ]],
    }
    use 'machakann/vim-highlightedyank'
    use {
      'akinsho/nvim-bufferline.lua',
      config = [[ require 'plugins.nvim_bufferline' ]],
      requires = 'kyazdani42/nvim-web-devicons',
    }
    use 'onsails/lspkind-nvim'
    use {
      'ray-x/lsp_signature.nvim',
      config = [[ require 'plugins.lsp_signature' ]],
    }

    -- Command
    use {
      'nvim-telescope/telescope.nvim',
      config = [[ require 'plugins.telescope' ]],
      requires = {
        'nvim-lua/popup.nvim',
        'nvim-lua/plenary.nvim',
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
        },
      },
    }
    use {
      'kyazdani42/nvim-tree.lua',
      config = [[ require 'plugins.nvim_tree' ]],
      requires = 'kyazdani42/nvim-web-devicons',
    }
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-repeat'
    use {
      'windwp/nvim-autopairs',
      config = [[ require 'plugins.nvim_autopairs' ]],
    }
    use 'tpope/vim-fugitive'
    use 'vim-scripts/ReplaceWithRegister'
    use {
      'tpope/vim-commentary',
      config = [[ require 'plugins.vim_commentary' ]],
    }
    use 'tpope/vim-surround'
    use {
      'justinmk/vim-sneak',
      config = [[ require 'plugins.vim_sneak' ]],
    }
    use 'nelstrom/vim-visual-star-search'
    use {
      'bkad/camelcasemotion',
      config = [[ require 'plugins.camelcasemotion' ]],
    }
    use 'AndrewRadev/splitjoin.vim'
    use 'junegunn/vim-peekaboo'
    use {
      'ojroques/vim-oscyank',
      config = [[ require 'plugins.vim_oscyank' ]],
    }

    -- Text objects
    use 'tommcdo/vim-exchange'
    use 'vim-scripts/argtextobj.vim'
  end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    },
  },
})
