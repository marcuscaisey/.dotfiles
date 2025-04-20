local ok, telescope = pcall(require, 'telescope')
if not ok then
  return
end
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local entry_display = require('telescope.pickers.entry_display')
local layout = require('telescope.actions.layout')
local make_entry = require('telescope.make_entry')
local mt = require('telescope.actions.mt')
local state = require('telescope.actions.state')

--- Shortens the given path by either:
--- - making it relative if it's part of the cwd
--- - replacing the home directory with ~ if not
---@param path string
---@return string
local function shorten_path(path)
  return vim.fs.relpath(vim.fn.getcwd(), path) or path:gsub('^' .. vim.pesc(vim.env.HOME), '~')
end

local custom_actions = mt.transform_mod({
  open_first_qf_item = function(_)
    vim.cmd.cfirst()
  end,
  open_first_loc_item = function(_)
    vim.cmd.lfirst()
  end,
})

---@class LspSymbolsEntryMakerOpts
---@field show_filename boolean

---@param opts LspSymbolsEntryMakerOpts
---@return fun(entry):table
local function lsp_symbols_entry_maker(opts)
  local max_symbol_kind_length = 0
  for _, kind in ipairs(vim.lsp.protocol.SymbolKind) do
    max_symbol_kind_length = math.max(max_symbol_kind_length, #kind)
  end
  local items = {
    { width = max_symbol_kind_length }, -- symbol type
    { remaining = true }, -- symbol name
  }
  if opts.show_filename then
    table.insert(items, { remaining = true }) -- filepath
  end

  local displayer = entry_display.create({ separator = ' ', items = items })
  local function make_display(entry)
    local args = {
      { entry.symbol_type, string.format('LspItemKind%s', entry.symbol_type) },
      entry.symbol_name,
    }
    if opts.show_filename then
      table.insert(args, { shorten_path(entry.filename), 'TelescopeResultsLineNr' })
    end
    return displayer(args)
  end

  local default_entry_maker = make_entry.gen_from_lsp_symbols()
  return function(entry)
    local default_entry = default_entry_maker(entry)
    default_entry.display = make_display
    default_entry.ordinal = default_entry.symbol_type .. ' ' .. default_entry.symbol_name
    if opts.show_filename then
      default_entry.ordinal = default_entry.ordinal .. ' ' .. default_entry.filename
    end
    return default_entry
  end
end

---@return fun(entry):table
local function lsp_location_entry_maker()
  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { remaining = true }, -- filename
      { remaining = true }, -- line:col
      { remaining = true }, -- directory
    },
  })
  local function make_display(entry)
    return displayer({
      vim.fs.basename(entry.filename),
      { entry.lnum .. ':' .. entry.col, 'TelescopeResultsLineNr' },
      { shorten_path(vim.fs.dirname(entry.filename)), 'TelescopeResultsLineNr' },
    })
  end

  local default_entry_maker = make_entry.gen_from_quickfix()
  return function(entry)
    local default_entry = default_entry_maker(entry)
    default_entry.display = make_display
    return default_entry
  end
end

telescope.setup({
  defaults = {
    layout_config = {
      horizontal = {
        width = 0.9,
        height = 0.9,
        prompt_position = 'top',
        preview_width = 0.5,
      },
    },
    mappings = {
      i = {
        ['<C-H>'] = layout.toggle_preview,
        -- If we're in the quickfix window and the only other window that is open is displaying a buffer with buftype
        -- set (like an oil.nvim window which has buftype=acwrite), then :cfirst (I think more generally any quickfix
        -- jump command like :cc, :cnext etc) will open a new split above the quickfix instead of using the open window.
        -- Jumping to the first quickfix item first avoids this.
        -- Relevant source:
        -- https://github.com/neovim/neovim/blob/c4e9ff30a6b6807c42bcf39dc312262cd2a22f32/src/nvim/quickfix.c#L2976-L2985
        -- https://github.com/neovim/neovim/blob/c4e9ff30a6b6807c42bcf39dc312262cd2a22f32/src/nvim/quickfix.c#L2760-L2763
        ['<C-Q>'] = actions.smart_send_to_qflist
          + custom_actions.open_first_qf_item
          + actions.open_qflist
          -- Jump to the first quickfix item after opening the quickfix list to leave in the main window.
          + custom_actions.open_first_qf_item,
        ['<C-L>'] = actions.smart_send_to_loclist + actions.open_loclist + custom_actions.open_first_loc_item,
      },
      n = {
        ['<C-H>'] = layout.toggle_preview,
        ['<C-C>'] = actions.close,
        ['<C-N>'] = actions.move_selection_next,
        ['<C-P>'] = actions.move_selection_previous,
        ['<C-Q>'] = actions.smart_send_to_qflist + custom_actions.open_first_qf_item + actions.open_qflist + custom_actions.open_first_qf_item,
        ['<C-L>'] = actions.smart_send_to_loclist + actions.open_loclist + custom_actions.open_first_loc_item,
      },
    },
    sorting_strategy = 'ascending',
    prompt_prefix = ' 🔍 ',
    selection_caret = '  ',
    multi_icon = ' 🔘 ',
    vimgrep_arguments = {
      'rg',
      '--hidden',
      '--glob=!.git',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    path_display = function(_, path)
      return shorten_path(path)
    end,
  },
  pickers = {
    find_files = {
      find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix', '--follow', '--hidden', '--exclude', '.git' },
    },
    oldfiles = {
      cwd_only = true,
      prompt_title = 'Oldfiles (cwd)',
      attach_mappings = function(_, map)
        map({ 'i', 'n' }, '<C-T>', function(prompt_bufnr)
          local picker = state.get_current_picker(prompt_bufnr)
          local opts = { default_text = state.get_current_line() }
          if picker.prompt_title == 'Oldfiles (cwd)' then
            opts.cwd_only = false
            opts.prompt_title = 'Oldfiles (all)'
          end
          builtin.oldfiles(opts)
        end)
        return true
      end,
    },
    current_buffer_fuzzy_find = {
      prompt_title = 'Current Buffer Fuzzy',
      attach_mappings = function(_, map)
        map({ 'i', 'n' }, '<C-T>', function(prompt_bufnr)
          actions.close(prompt_bufnr)
          builtin.live_grep({
            search_dirs = { vim.api.nvim_buf_get_name(0) },
            prompt_title = 'Current Buffer Live Grep',
            default_text = state.get_current_line(),
            path_display = { 'tail' },
          })
        end)
        return true
      end,
    },
    buffers = {
      sort_mru = true,
      ignore_current_buffer = true,
    },
    lsp_document_symbols = { entry_maker = lsp_symbols_entry_maker({ show_filename = false }) },
    lsp_dynamic_workspace_symbols = {
      entry_maker = lsp_symbols_entry_maker({ show_filename = true }),
      sorter = telescope.extensions.fzf.native_fzf_sorter(),
    },
    lsp_references = {
      entry_maker = lsp_location_entry_maker(),
      include_current_line = true,
      jump_type = 'never',
    },
    lsp_implementations = { entry_maker = lsp_location_entry_maker() },
    lsp_definitions = { entry_maker = lsp_location_entry_maker() },
  },
  extensions = {
    olddirs = {
      git_repo_only = true,
      layout_config = {
        width = 0.6,
        height = 0.9,
      },
      previewer = false,
      prompt_title = 'Olddirs (git repo)',
      attach_mappings = function(_, map)
        map({ 'i', 'n' }, '<C-T>', function(prompt_bufnr)
          local picker = state.get_current_picker(prompt_bufnr)
          local opts = { default_text = state.get_current_line() }
          if picker.prompt_title == 'Olddirs (git repo)' then
            opts.git_repo_only = false
            opts.prompt_title = 'Olddirs (all)'
          end
          telescope.extensions.olddirs.picker(opts)
        end)
        return true
      end,
    },
  },
})
telescope.load_extension('fzf')
telescope.load_extension('olddirs')

vim.keymap.set('n', '<C-P>', builtin.find_files, { desc = 'telescope.builtin.find_files()' })
vim.keymap.set('n', '<C-B>', builtin.buffers, { desc = 'telescope.builtin.buffers()' })
vim.keymap.set('n', '<C-G>', builtin.live_grep, { desc = 'telescope.builtin.live_grep()' })
vim.keymap.set('n', '<Leader>/', builtin.current_buffer_fuzzy_find, { desc = 'telescope.builtin.current_buffer_fuzzy_find()' })
vim.keymap.set('n', '<Leader>ht', builtin.help_tags, { desc = 'telescope.builtin.help_tags()' })
vim.keymap.set('n', '<Leader>of', builtin.oldfiles, { desc = 'telescope.builtin.oldfiles()' })
vim.keymap.set('n', '<Leader>tt', builtin.builtin, { desc = 'telescope.builtin.builtin()' })
vim.keymap.set('n', '<Leader>tr', builtin.resume, { desc = 'telescope.builtin.resume()' })
vim.keymap.set('n', '<Leader>od', telescope.extensions.olddirs.picker, { desc = 'telescope.extensions.olddirs.picker()' })
vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { desc = 'telescope.builtin.lsp_document_symbols()' })
vim.keymap.set('n', 'gwO', builtin.lsp_dynamic_workspace_symbols, { desc = 'telescope.builtin.lsp_dynamic_workspace_symbols()' })
vim.keymap.set('n', 'g]', function()
  if vim.opt_local.tagfunc:get() == 'v:lua.vim.lsp.tagfunc' then
    builtin.lsp_definitions({ jump_type = 'never' })
    return '<Ignore>'
  else
    return 'g]'
  end
end, { expr = true, desc = [[telescope.builtin.lsp_definitions({ jump_type = 'never' )]] })
vim.keymap.set('n', 'g<C-]>', function()
  if vim.opt_local.tagfunc:get() == 'v:lua.vim.lsp.tagfunc' then
    builtin.lsp_definitions()
    return '<Ignore>'
  else
    return 'g<C-]>'
  end
end, { expr = true, desc = 'telescope.builtin.lsp_definitions()' })
vim.keymap.set('n', 'gri', builtin.lsp_implementations, { desc = 'telescope.builtin.lsp_implementations()' })
vim.keymap.set('n', 'grr', builtin.lsp_references, { desc = 'telescope.builtin.lsp_references()' })
