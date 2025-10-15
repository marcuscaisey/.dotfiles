---@class SpecData
---@field runtimepath string? subdirectory of plugin to add to runtimepath
---@field defer boolean? defer loading plugin
---@field post_install string? command to run after plugin install/update

---@class Spec : vim.pack.Spec
---@field data SpecData?

---@class SpecResolved : Spec
---@field name string

vim.api.nvim_create_autocmd('PackChanged', {
  group = vim.api.nvim_create_augroup('pack_post_install_commands', {}),
  desc = 'Run post installation commands',
  ---@class PackChangedCallbackArgs : vim.api.keyset.create_autocmd.callback_args
  ---@field data {kind:'install'|'update'|'delete', spec:SpecResolved, path:string}
  ---@param args PackChangedCallbackArgs
  callback = function(args)
    local spec = args.data.spec
    if args.data.kind ~= 'update' or not spec.data or not spec.data.post_install then
      return
    end
    vim.notify('Running ' .. spec.name .. ' post-install command: ' .. spec.data.post_install, vim.log.levels.INFO)
    local ok = true
    local err = nil ---@type string?
    if vim.startswith(spec.data.post_install, ':') then
      ok, err = pcall(function()
        vim.cmd(spec.data.post_install)
      end)
    else
      local obj = vim.system(vim.split(spec.data.post_install, ' '), { cwd = args.data.path }):wait()
      ok = obj.code == 0
      err = obj.stderr
    end
    if ok then
      vim.notify(spec.name .. ' post-install command successful', vim.log.levels.INFO)
    else
      vim.notify(spec.name .. ' post-install command failed: ' .. err, vim.log.levels.ERROR)
    end
  end,
})

---@type Spec[]
local specs = {
  { src = 'https://github.com/bkad/camelcasemotion' },
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
  { src = 'https://github.com/jake-stewart/multicursor.nvim' },
  { src = 'https://github.com/kosayoda/nvim-lightbulb' },
  { src = 'https://github.com/kyazdani42/nvim-web-devicons' },
  { src = 'https://github.com/kylechui/nvim-surround' },
  -- Pin version until https://github.com/lewis6991/gitsigns.nvim/issues/1381 is fixed.
  { src = 'https://github.com/lewis6991/gitsigns.nvim', version = '60676707b6a5fa42369e8ff40a481ca45987e0d0' },
  { src = 'https://github.com/marcuscaisey/lox', data = { runtimepath = 'tree-sitter-lox' } },
  { src = 'https://github.com/marcuscaisey/olddirs.nvim' },
  { src = 'https://github.com/marcuscaisey/please.nvim' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' }, -- Required for telescope.nvim
  { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', data = { post_install = 'make' } },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', data = { post_install = ':TSUpdate' } },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' },
  { src = 'https://github.com/saghen/blink.cmp', data = { post_install = 'cargo build --release' } },
  { src = 'https://github.com/stevearc/dressing.nvim' },
  { src = 'https://github.com/stevearc/oil.nvim' },
  { src = 'https://github.com/tpope/vim-fugitive' },
  { src = 'https://github.com/vim-scripts/ReplaceWithRegister', data = { defer = true } },
}

vim.pack.add(specs, {
  ---@param plug_data {spec:Spec, path:string}
  load = function(plug_data)
    local data = plug_data.spec.data or {}
    if not data.defer then
      vim.cmd('packadd! ' .. plug_data.spec.name)
    end
    if data.runtimepath then
      vim.opt.runtimepath:append(vim.fs.joinpath(plug_data.path, data.runtimepath))
    end
  end,
})

vim.cmd.packadd('nvim.undotree')
