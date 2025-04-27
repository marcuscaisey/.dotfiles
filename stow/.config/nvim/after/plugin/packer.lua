local install_path = vim.fs.joinpath(vim.fn.stdpath('data') --[[@as string]], 'site/pack/packer/start')
local packer_install_path = vim.fs.joinpath(install_path, 'packer.nvim')
local bootstrap = false
if not vim.loop.fs_stat(packer_install_path) then
  local res = vim.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_install_path }):wait()
  assert(res.code == 0, string.format('Failed to clone packer.nvim. stderr:\n%s', res.stderr))
  vim.opt.runtimepath:append(packer_install_path)
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
    use({ 'kosayoda/nvim-lightbulb' })
    use({ 'saghen/blink.cmp', run = 'cargo build --release' })
    use({ 'kyazdani42/nvim-web-devicons' })
    use({ 'lewis6991/gitsigns.nvim' })
    use({ 'stevearc/dressing.nvim' })
    use({ 'catppuccin/nvim', as = 'catppuccin' })
    use({ 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } })
    use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', requires = { 'nvim-telescope/telescope.nvim' } })
    use({ 'vim-scripts/ReplaceWithRegister', opt = true })
    use({ 'kylechui/nvim-surround' })
    use({ 'bkad/camelcasemotion' })
    use({ 'tpope/vim-fugitive' })
    use({ 'marcuscaisey/please.nvim' })
    use({ 'yorickpeterse/nvim-pqf' })
    use({ 'marcuscaisey/olddirs.nvim', requires = { 'nvim-telescope/telescope.nvim' } })
    use({ 'github/copilot.vim', opt = true })
    use({ 'marcuscaisey/lox' })
    use({ 'stevearc/oil.nvim' })
    use({ 'jake-stewart/multicursor.nvim' })
    use({ 'm4xshen/hardtime.nvim', requires = { 'MunifTanjim/nui.nvim' } })

    if bootstrap then
      vim.api.nvim_create_autocmd('User', {
        group = vim.api.nvim_create_augroup('packer', { clear = true }),
        pattern = 'PackerComplete',
        desc = 'Load plugins and configuration after installation',
        callback = function()
          vim.ui.select({ 'Yes', 'No' }, { prompt = "Installed plugins won't be configured until nvim is restarted. Exit?" }, function(choice)
            if choice == 'Yes' then
              vim.cmd.quitall()
            end
          end)
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

vim.opt.runtimepath:append(vim.fs.joinpath(install_path, 'lox/tree-sitter-lox'))
