local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path })
  vim.cmd.packadd('packer.nvim')
end

local packer = require('packer')
local util = require('packer.util')

packer.startup({
  function(use)
    use('wbthomason/packer.nvim')
    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate',
      config = function()
        require('plugins.treesitter')
      end,
    })
    use('nvim-treesitter/nvim-treesitter-textobjects')
    use('lewis6991/nvim-treesitter-context')
    use('nvim-treesitter/playground')
    use('windwp/nvim-ts-autotag')
    use({
      'neovim/nvim-lspconfig',
      config = function()
        require('plugins.lspconfig')
      end,
      requires = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
      },
    })
    use({
      'williamboman/mason.nvim',
      config = function()
        require('mason').setup()
      end,
    })
    use('williamboman/mason-lspconfig.nvim')
    use({
      'kosayoda/nvim-lightbulb',
      requires = 'antoinemadec/FixCursorHold.nvim',
      config = function()
        require('plugins.lightbulb')
      end,
    })
    use({
      'hrsh7th/nvim-cmp',
      config = function()
        require('plugins.cmp')
      end,
    })
    use({
      'saadparwaiz1/cmp_luasnip',
      config = function()
        require('plugins.luasnip')
      end,
    })
    use('hrsh7th/cmp-nvim-lsp')
    use('hrsh7th/cmp-nvim-lua')
    use('hrsh7th/cmp-buffer')
    use({
      'mfussenegger/nvim-dap',
      config = function()
        require('plugins.dap')
      end,
    })
    use({
      'theHamsta/nvim-dap-virtual-text',
      config = function()
        require('nvim-dap-virtual-text').setup({})
      end,
    })
    use({
      'rcarriga/nvim-dap-ui',
      config = function()
        require('plugins.dap_ui')
      end,
    })
    use('L3MON4D3/LuaSnip')
    use({
      'ray-x/lsp_signature.nvim',
      config = function()
        require('plugins.lsp_signature')
      end,
    })
    use({
      'nvim-lualine/lualine.nvim',
      requires = 'kyazdani42/nvim-web-devicons',
      config = function()
        require('plugins.lualine')
      end,
    })
    use({
      'j-hui/fidget.nvim',
      config = function()
        require('fidget').setup()
      end,
    })
    use({
      'lewis6991/gitsigns.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('plugins.gitsigns')
      end,
    })
    use('stevearc/dressing.nvim')
    use({
      'catppuccin/nvim',
      config = function()
        require('plugins.catppuccin')
      end,
    })
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
      config = function()
        require('plugins.telescope')
      end,
    })
    use({
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
    })
    use('tpope/vim-eunuch')
    use({
      'windwp/nvim-autopairs',
      config = function()
        require('nvim-autopairs').setup()
      end,
    })
    use({
      'vim-scripts/ReplaceWithRegister',
      config = function()
        require('plugins.replace_with_register')
      end,
    })
    use({
      'numToStr/Comment.nvim',
      config = function()
        require('Comment').setup()
      end,
    })
    use({
      'kylechui/nvim-surround',
      config = function()
        require('nvim-surround').setup()
      end,
    })
    use({
      'ggandor/leap.nvim',
      config = function()
        require('plugins.leap')
      end,
    })
    use({
      'bkad/camelcasemotion',
      config = function()
        require('plugins.camel_case_motion')
      end
    })
    use({
      'jose-elias-alvarez/null-ls.nvim',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('plugins.null_ls')
      end,
    })
    use('svban/YankAssassin.vim')
    use({
      'tpope/vim-fugitive',
      config = function()
        require('plugins.fugitive')
      end,
    })
    use({
      'ThePrimeagen/harpoon',
      requires = 'nvim-lua/plenary.nvim',
      config = function()
        require('plugins.harpoon')
      end,
    })
    use({
      'marcuscaisey/please.nvim',
      config = function()
        require('plugins.please')
      end,
    })
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
      config = function()
        require('plugins.git_conflict')
      end,
      after = 'nvim',
    })
    use({
      'https://gitlab.com/yorickpeterse/nvim-pqf',
      config = function()
        require('pqf').setup()
      end,
    })
    use({
      'marcuscaisey/tui-nvim',
      branch = 'winhl-fix',
      config = function()
        require('plugins.tui')
      end,
    })
    use('marcuscaisey/olddirs.nvim')
    use({
      'tpope/vim-projectionist',
      config = function()
        require('plugins.projectionist')
      end,
    })
  end,
  config = {
    display = {
      open_fn = util.float,
    },
  },
})
