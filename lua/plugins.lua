local g = vim.g
local fn = vim.fn
local cmd = vim.cmd
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local execute = vim.api.nvim_command

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])

require('packer').startup({
  function(use)
    use {
      'wbthomason/packer.nvim',
      event = 'VimEnter',
    }

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
      requires = 'kyazdani42/nvim-web-devicons',
    }
    use 'airblade/vim-gitgutter'
    use 'machakann/vim-highlightedyank'
    use {
      'akinsho/nvim-bufferline.lua',
      requires = 'kyazdani42/nvim-web-devicons',
    }

    -- Command
    use {
      'nvim-telescope/telescope.nvim',
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
      requires = 'kyazdani42/nvim-web-devicons',
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
    show_close_icon = false,
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
cmd('autocmd ColorScheme * highlight! link Sneak IncSearch')
g['sneak#use_ic_scs'] = 1

-- camelcasemotion
g.camelcasemotion_key = '<leader>'

-- nvim-tree
local tree_cb = require('nvim-tree.config').nvim_tree_callback
g.nvim_tree_bindings = {
  {key = 'h', cb = tree_cb('close_node')},
  {key = 'l', cb = tree_cb("edit")},
}
g.nvim_tree_ignore = {'.git'}
g.nvim_tree_auto_close = 1
g.nvim_tree_quit_on_open = 1
g.nvim_tree_follow = 1
g.nvim_tree_hide_dotfiles = 1
g.nvim_tree_git_hl = 1
g.nvim_tree_highlight_opened_files = 1
g.nvim_tree_group_empty = 1

-- vim-gitgutter
g.gitgutter_close_preview_on_escape = 1

-- telescope.nvim
local telescope = require('telescope')
telescope.setup {
  defaults = {
    layout_config = {
      horizontal = {
        preview_width = 0.6,
        width = 0.9,
      },
    },
    prompt_prefix = ' 🔍  ',
    selection_caret = '  ',
  },
  pickers = {
    current_buffer_fuzzy_find = {
      previewer = false,
      sorting_strategy = 'ascending',
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    },
  },
}

telescope.load_extension('fzf')
