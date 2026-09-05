vim.api.nvim_create_autocmd('PackChanged', {
    desc = 'Run post installation commands',
    group = vim.api.nvim_create_augroup('my.pack.post_install_commands'),
    callback = function(ev)
        local active, kind, spec = ev.data.active, ev.data.kind, ev.data.spec
        if not (kind == 'update' or kind == 'install') then
            return
        end
        if spec.name == 'nvim-treesitter' then
            if not active then
                vim.cmd.packadd('nvim-treesitter')
            end
            vim.cmd.TSUpdate()
        end
    end,
})

-- Must be done before ReplaceWithRegister is loaded
vim.keymap.set('n', '<Leader>r', '<Plug>ReplaceWithRegisterOperator')
vim.keymap.set('n', '<Leader>rr', '<Plug>ReplaceWithRegisterLine')
vim.keymap.set('v', '<Leader>r', '<Plug>ReplaceWithRegisterVisual')

vim.pack.add({
    { src = 'https://github.com/bkad/camelcasemotion' },
    { src = 'https://github.com/gbprod/nord.nvim' },
    { src = 'https://github.com/ibhagwan/fzf-lua' },
    { src = 'https://github.com/inkarkat/vim-ReplaceWithRegister' },
    { src = 'https://github.com/kosayoda/nvim-lightbulb' },
    { src = 'https://github.com/kyazdani42/nvim-web-devicons' },
    { src = 'https://github.com/kylechui/nvim-surround' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' },
    { src = 'https://github.com/linrongbin16/gitlinker.nvim' },
    { src = 'https://github.com/marcuscaisey/olddirs.nvim' },
    { src = 'https://github.com/marcuscaisey/please.nvim' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/michaeljsmith/vim-indent-object' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/nvim-mini/mini.completion' },
    { src = 'https://github.com/nvim-mini/mini.splitjoin' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
    { src = 'https://github.com/tpope/vim-eunuch' },
    { src = 'https://github.com/tpope/vim-fugitive' },
})

vim.cmd.packadd('nvim.undotree')
