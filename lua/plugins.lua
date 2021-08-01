local g = vim.g
local fn = vim.fn
local cmd = vim.cmd
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local execute = vim.api.nvim_command

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

require('packer').startup({
  function(use)
    -- Syntax
    use {
      'nvim-treesitter/nvim-treesitter',
      run = ':TSUpdate'
    }

    -- UI
    use {
      'glepnir/galaxyline.nvim',
      branch = 'main',
      config = function() require 'statusline' end,
      requires = {'kyazdani42/nvim-web-devicons', opt = true},
    }
    use 'airblade/vim-gitgutter'
    use 'machakann/vim-highlightedyank'
    use {
      'akinsho/nvim-bufferline.lua',
      requires = {'kyazdani42/nvim-web-devicons', opt = true},
    }

    -- Command
    -- use '~/.fzf'
    -- use 'junegunn/fzf.vim'
    use {
      'kyazdani42/nvim-tree.lua',
      requires = {'kyazdani42/nvim-web-devicons', opt = true},
    }
    use 'tpope/vim-unimpaired'
    use 'tpope/vim-eunuch'
    use 'tpope/vim-repeat'
    use 'jiangmiao/auto-pairs'
    use 'tpope/vim-fugitive'
    use 'ConradIrwin/vim-bracketed-paste'
    use 'vim-scripts/ReplaceWithRegister'
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'junegunn/vim-easy-align'
    use 'justinmk/vim-sneak'
    use 'nelstrom/vim-visual-star-search'
    use 'bkad/camelcasemotion'
    use 'AndrewRadev/splitjoin.vim'
    use 'junegunn/vim-peekaboo'

    -- Text objects
    use 'wellle/targets.vim'
    use 'michaeljsmith/vim-indent-object'
    use 'kana/vim-textobj-user'
    use 'kana/vim-textobj-entire'
    use 'tommcdo/vim-exchange'
    use 'vim-scripts/argtextobj.vim'
  end,
  config = {
    display = {
      open_fn = require('packer.util').float,
    }
  },
})


--------------------------------------------------------------------------------
--                                  settings
--------------------------------------------------------------------------------
-- commentary.vim
cmd('autocmd FileType sql setlocal commentstring=--%s')

-- nvim-bufferline.lua
require('bufferline').setup{
  highlights = {
    buffer_selected = {
      gui = 'bold',
    },
  },
  options = {
    show_buffer_close_icons = false,
  },
}

-- nvim-treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true,
    disable = {'yaml'},
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true,
  },
}


-- vim-sneak
cmd('highlight link Sneak IncSearch')
g['sneak#use_ic_scs'] = 1

-- camelcasemotion
g.camelcasemotion_key = '<leader>'
