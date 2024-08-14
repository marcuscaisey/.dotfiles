local ok, telescope = pcall(require, 'telescope')
if not ok then
  return
end
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local entry_display = require('telescope.pickers.entry_display')
local layout = require('telescope.actions.layout')
local transform_mod = require('telescope.actions.mt').transform_mod

--- Shortens the given path by either:
--- - making it relative if it's part of the cwd
--- - replacing the home directory with ~ if not
---@param path string
---@return string
local function shorten_path(path)
  local cwd = assert(vim.uv.cwd())
  if path == cwd then
    return ''
  end
  local relative_path, replacements = path:gsub('^' .. vim.pesc(cwd .. '/'), '')
  if replacements == 1 then
    return relative_path
  end
  local path_without_home = path:gsub('^' .. vim.pesc(assert(os.getenv('HOME'), '$HOME not set')), '~')
  return path_without_home
end

local custom_actions = transform_mod({
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

  return function(entry)
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
        { entry.symbol_type, 'CmpItemKind' .. entry.symbol_type },
        entry.symbol_name,
      }
      if opts.show_filename then
        table.insert(args, { shorten_path(entry.filename), 'TelescopeResultsLineNr' })
      end
      return displayer(args)
    end

    return {
      valid = true,
      value = entry,
      ordinal = entry.filename .. entry.text,
      display = make_display,
      filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr),
      lnum = entry.lnum,
      col = entry.col,
      symbol_name = entry.text:match('%[.+%]%s+(.*)'),
      symbol_type = entry.kind,
      start = entry.start,
      finish = entry.finish,
    }
  end
end

local function lsp_location_entry_maker(entry)
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

  return {
    valid = true,
    value = entry,
    ordinal = entry.filename .. entry.text,
    display = make_display,
    bufnr = entry.bufnr,
    filename = entry.filename,
    lnum = entry.lnum,
    col = entry.col,
    text = entry.text,
    start = entry.start,
    finish = entry.finish,
  }
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
    borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    mappings = {
      i = {
        ['<c-h>'] = layout.toggle_preview,
        ['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist + custom_actions.open_first_qf_item,
        ['<c-l>'] = actions.smart_send_to_loclist + actions.open_loclist + custom_actions.open_first_loc_item,
      },
      n = {
        ['<c-h>'] = layout.toggle_preview,
        ['<c-c>'] = actions.close,
        ['<c-n>'] = actions.move_selection_next,
        ['<c-p>'] = actions.move_selection_previous,
        ['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist + custom_actions.open_first_qf_item,
        ['<c-l>'] = actions.smart_send_to_loclist + actions.open_loclist + custom_actions.open_first_loc_item,
      },
    },
    sorting_strategy = 'ascending',
    prompt_prefix = ' 🔍 ',
    selection_caret = '  ',
    multi_icon = ' 🔘 ',
  },
  pickers = {
    find_files = {
      find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix', '--follow', '--hidden', '--exclude', '.git' },
    },
    oldfiles = {
      cwd_only = true,
      path_display = function(_, path)
        return shorten_path(path)
      end,
    },
    buffers = {
      sort_mru = true,
      ignore_current_buffer = true,
    },
    lsp_document_symbols = { entry_maker = lsp_symbols_entry_maker({ show_filename = false }) },
    lsp_dynamic_workspace_symbols = { entry_maker = lsp_symbols_entry_maker({ show_filename = true }) },
    lsp_references = { entry_maker = lsp_location_entry_maker },
    lsp_implementations = { entry_maker = lsp_location_entry_maker },
    lsp_definitions = { entry_maker = lsp_location_entry_maker },
  },
  extensions = {
    olddirs = {
      layout_config = {
        width = 0.6,
        height = 0.9,
      },
      previewer = false,
      path_display = function(_, path)
        return shorten_path(path)
      end,
    },
  },
})
telescope.load_extension('fzf')
telescope.load_extension('olddirs')

-- stylua: ignore start
vim.keymap.set('n', '<c-p>', builtin.find_files, { desc = 'telescope.builtin.find_files()' })
vim.keymap.set('n', '<c-b>', function ()
  builtin.buffers({ sort_mru = true })
end, { desc = 'telescope.builtin.buffers()' })
vim.keymap.set('n', '<c-g>', builtin.live_grep, { desc = 'telescope.builtin.live_grep()' })
vim.keymap.set('n', '<leader>ht', builtin.help_tags, { desc = 'telescope.builtin.help_tags()' })
vim.keymap.set('n', '<leader>of', builtin.oldfiles, { desc = 'telescope.builtin.oldfiles()' })
vim.keymap.set('n', '<leader>oaf', function()
  builtin.oldfiles({ cwd_only = false })
end, { desc = 'telescope.builtin.oldfiles()' })
vim.keymap.set('n', '<leader>tt', builtin.builtin, { desc = 'telescope.builtin.builtin()' })
vim.keymap.set('n', '<leader>tr', builtin.resume, { desc = 'telescope.builtin.resume()' })
vim.keymap.set('n', '<leader>od', telescope.extensions.olddirs.picker, { desc = 'telescope.extensions.olddirs.picker()' })
vim.keymap.set('n', 'grs', builtin.lsp_document_symbols, { desc = 'telescope.builtin.lsp_document_symbols()' })
vim.keymap.set('n', 'grS', builtin.lsp_dynamic_workspace_symbols, { desc = 'telescope.builtin.lsp_dynamic_workspace_symbols()' })
vim.keymap.set('n', 'gd', builtin.lsp_definitions, { desc = 'telescope.builtin.lsp_definitions()' })
vim.keymap.set('n', 'gri', builtin.lsp_implementations, { desc = 'telescope.builtin.lsp_implementations()' })
vim.keymap.set('n', 'grr', function()
  builtin.lsp_references({ jump_type = 'never', include_current_line = true })
end, { desc = 'telescope.builtin.lsp_references()' })
-- stylua: ignore end
