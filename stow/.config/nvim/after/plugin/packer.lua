local install_path = vim.fs.joinpath(vim.fn.stdpath('data') --[[@as string]], 'site/pack/packer/start/packer.nvim')
local bootstrap = false
if not vim.loop.fs_stat(install_path) then
  local res = vim.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path }):wait()
  assert(res.code == 0, string.format('Failed to clone packer.nvim. stderr:\n%s', res.stderr))
  vim.opt.runtimepath:append(install_path)
  bootstrap = true
end

local packer = require('packer')
local util = require('packer.util')

packer.startup({
  function(use)
    use({ 'wbthomason/packer.nvim' })
    use({ 'nvim-treesitter/nvim-treesitter' })
    use({ 'nvim-treesitter/nvim-treesitter-textobjects', requires = { 'nvim-treesitter/nvim-treesitter' } })
    use({ 'nvim-treesitter/nvim-treesitter-context' })
    use({ 'neovim/nvim-lspconfig' })
    use({ 'williamboman/mason.nvim' })
    use({ 'williamboman/mason-lspconfig.nvim', requires = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' } })
    use({ 'kosayoda/nvim-lightbulb' })
    use({ 'hrsh7th/nvim-cmp' })
    use({ 'hrsh7th/cmp-nvim-lsp', requires = { 'hrsh7th/nvim-cmp' } })
    use({ 'hrsh7th/cmp-buffer', requires = { 'hrsh7th/nvim-cmp' } })
    use({ 'mfussenegger/nvim-dap' })
    use({ 'rcarriga/nvim-dap-ui', requires = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' } })
    use({ 'ray-x/lsp_signature.nvim' })
    use({ 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons' } })
    use({ 'lewis6991/gitsigns.nvim' })
    use({ 'stevearc/dressing.nvim' })
    use({ 'catppuccin/nvim', as = 'catppuccin' })
    use({ 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } })
    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', requires = { 'nvim-telescope/telescope.nvim' } })
    use({ 'vim-scripts/ReplaceWithRegister' })
    use({ 'kylechui/nvim-surround' })
    use({ 'bkad/camelcasemotion' })
    use({ 'jose-elias-alvarez/null-ls.nvim', requires = { 'nvim-lua/plenary.nvim' } })
    use({ 'tpope/vim-fugitive' })
    use({ 'marcuscaisey/please.nvim', requires = { 'nvim-treesitter/nvim-treesitter', 'mfussenegger/nvim-dap' } })
    use({ 'tpope/vim-abolish' })
    use({ 'yorickpeterse/nvim-pqf' })
    use({ 'marcuscaisey/tui-nvim' })
    use({ 'marcuscaisey/olddirs.nvim', requires = { 'nvim-telescope/telescope.nvim' } })
    use({ 'tpope/vim-projectionist' })
    use({ 'folke/neodev.nvim' })
    use({ 'tpope/vim-eunuch' })
    use({ 'github/copilot.vim' })
    use({ 'norcalli/nvim-colorizer.lua' })
    use({ 'marcuscaisey/tree-sitter-lox' })

    if bootstrap then
      vim.api.nvim_create_autocmd('User', {
        group = vim.api.nvim_create_augroup('packer', { clear = true }),
        pattern = 'PackerComplete',
        desc = 'Load plugins and configuration after installation',
        callback = function()
          vim.ui.select(
            { 'Yes', 'No' },
            { prompt = "Installed plugins won't be configured until nvim is restarted. Exit?" },
            function(choice)
              if choice == 'Yes' then
                vim.cmd.quitall()
              end
            end
          )
        end,
        once = true,
      })
      packer.install()
    end
  end,
  config = {
    compile_on_sync = false,
    display = {
      open_fn = function()
        return util.float({ border = 'single' })
      end,
    },
  },
})
