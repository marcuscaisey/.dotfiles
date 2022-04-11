local telescope = require 'telescope'
local state = require 'telescope.actions.state'
local layout = require 'telescope.actions.state'
local builtin = require 'telescope.builtin'
local entry_display = require 'telescope.pickers.entry_display'
local utils = require 'telescope.utils'
local actions = require 'telescope.actions'
local transform_mod = require('telescope.actions.mt').transform_mod

--- Splits a filepath into head / tail where tail is the last path component and
--- head is everything before it.
---@param path string
---@return string head
---@return string tail
local function split_path(path)
  local tail = utils.path_tail(path)
  local head = path:gsub('/' .. tail .. '$', '')
  return head, tail
end

--- Shortens the given path by either:
--- - making it relative if it's part of the cwd
--- - replacing the home directory with ~ if not
---@param path string
---@return string
local function shorten_path(path)
  local cwd = vim.fn.getcwd()
  if path == cwd then
    return ''
  end
  -- need to escape - since its a special character in lua patterns
  cwd = cwd:gsub('%-', '%%-')
  local relative_path, replacements = path:gsub('^' .. cwd .. '/', '')
  if replacements == 1 then
    return relative_path
  end
  local path_without_home = path:gsub('^' .. os.getenv 'HOME', '~')
  return path_without_home
end

-- displays document symbols as: type name
local function create_lsp_document_symbols_entry(entry)
  local displayer = entry_display.create {
    separator = ' ',
    items = {
      { width = 13 }, -- symbol type
      { remaining = true }, -- symbol name
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.symbol_type, 'LSPSymbol' .. entry.symbol_type },
      entry.symbol_name,
    }
  end

  local symbol_msg = entry.text:gsub('.* | ', '')
  local symbol_type, symbol_name = symbol_msg:match '%[(.+)%]%s+(.*)'
  local ordinal = symbol_name .. ' ' .. (symbol_type or 'unknown')

  return {
    valid = true,
    value = entry,
    ordinal = ordinal,
    display = make_display,
    filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr),
    lnum = entry.lnum,
    col = entry.col,
    symbol_name = symbol_name,
    symbol_type = symbol_type,
    start = entry.start,
    finish = entry.finish,
  }
end

-- displays workspace symbols as: type name filepath
local function create_lsp_dynamic_workspace_symbols_entry(entry)
  local displayer = entry_display.create {
    separator = ' ',
    items = {
      { width = 13 }, -- symbol type
      { remaining = true }, -- symbol name
      { remaining = true }, -- filepath
    },
  }

  local make_display = function(entry)
    return displayer {
      { entry.symbol_type, 'LSPSymbol' .. entry.symbol_type },
      entry.symbol_name,
      { shorten_path(entry.filename), 'TelescopeResultsLineNr' },
    }
  end

  local symbol_msg = entry.text:gsub('.* | ', '')
  local symbol_type, symbol_name = symbol_msg:match '%[(.+)%]%s+(.*)'
  local ordinal = symbol_name .. ' ' .. (symbol_type or 'unknown')

  return {
    valid = true,
    value = entry,
    ordinal = ordinal,
    display = make_display,
    filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr),
    lnum = entry.lnum,
    col = entry.col,
    symbol_name = symbol_name,
    symbol_type = symbol_type,
    start = entry.start,
    finish = entry.finish,
  }
end

-- displays lsp references as: filename line:col directory
local function create_lsp_references_entry(entry)
  local displayer = entry_display.create {
    separator = ' ',
    items = {
      { remaining = true }, -- filename
      { remaining = true }, -- line:col
      { remaining = true }, -- directory
    },
  }

  local make_display = function(entry)
    local head, tail = split_path(entry.filename)
    head = shorten_path(head)

    local position = table.concat({ entry.lnum, entry.col }, ':')

    return displayer {
      tail,
      { position, 'TelescopeResultsLineNr' },
      { head, 'TelescopeResultsLineNr' },
    }
  end

  return {
    valid = true,
    value = entry,
    ordinal = entry.filename .. ' ' .. entry.text,
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

-- display lsp definitions as: filename directory
local function create_lsp_definitions_entry(entry)
  local displayer = entry_display.create {
    separator = ' ',
    items = {
      { remaining = true }, -- filename
      { remaining = true }, -- directory
    },
  }

  local make_display = function(entry)
    local head, tail = split_path(entry.filename)
    head = shorten_path(head)
    return displayer {
      tail,
      { head, 'TelescopeResultsLineNr' },
    }
  end

  return {
    valid = true,
    value = entry,
    ordinal = entry.filename .. ' ' .. entry.text,
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

local custom_actions = transform_mod {
  open_first_qf_item = function(_)
    vim.cmd 'cfirst'
  end,
  grep_in_files = function(prompt_bufnr)
    local picker = state.get_current_picker(prompt_bufnr)
    local selections = picker:get_multi_selection()
    local filenames = {}
    if #selections > 0 then
      for _, entry in pairs(selections) do
        table.insert(filenames, entry[1])
      end
    else
      for entry in picker.manager:iter() do
        table.insert(filenames, entry[1])
      end
    end
    actions.close(prompt_bufnr)
    -- There's some race condition occurring when you instantly open another telescope finder, causing the initial mode
    -- to be normal and not insert. Adding this tiny delay seems to fix it.
    vim.defer_fn(function()
      builtin.live_grep { search_dirs = filenames, initial_mode = 'insert' }
    end, 10)
  end,
}

telescope.setup {
  defaults = {
    layout_config = {
      horizontal = {
        width = 0.9,
        height = 0.9,
        prompt_position = 'top',
        preview_width = 0.5,
      },
      vertical = { width = 0.9 },
    },
    mappings = {
      i = {
        ['<c-h>'] = layout.toggle_preview,
        ['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist + custom_actions.open_first_qf_item,
      },
      n = {
        ['<c-h>'] = layout.toggle_preview,
        ['<c-c>'] = actions.close,
        ['<c-n>'] = actions.move_selection_next,
        ['<c-p>'] = actions.move_selection_previous,
        ['<c-q>'] = actions.smart_send_to_qflist + actions.open_qflist + custom_actions.open_first_qf_item,
      },
    },
    sorting_strategy = 'ascending',
    prompt_prefix = ' 🔍 ',
    selection_caret = '  ',
    multi_icon = ' 🔘 ',
  },
  pickers = {
    find_files = {
      layout_config = {
        width = 0.6,
        height = 0.9,
      },
      previewer = false,
      find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix', '--follow', '--hidden', '--exclude', '.git' },
      mappings = {
        i = {
          ['<c-g>'] = custom_actions.grep_in_files,
        },
        n = {
          ['<c-g>'] = custom_actions.grep_in_files,
        },
      },
    },
    oldfiles = {
      layout_config = {
        width = 0.6,
        height = 0.9,
      },
      previewer = false,
      path_display = function(opts, path)
        return shorten_path(path)
      end,
    },
    buffers = {
      layout_config = {
        width = 0.6,
        height = 0.6,
      },
      previewer = false,
      sort_mru = true,
      ignore_current_buffer = true,
      mappings = {
        i = {
          ['<c-d>'] = 'delete_buffer',
        },
        n = {
          ['<c-d>'] = 'delete_buffer',
        },
      },
    },
    live_grep = {
      layout_config = {
        preview_width = 0.4,
      },
    },
    current_buffer_fuzzy_find = {
      previewer = false,
    },
    lsp_document_symbols = {
      entry_maker = create_lsp_document_symbols_entry,
    },
    lsp_dynamic_workspace_symbols = {
      entry_maker = create_lsp_dynamic_workspace_symbols_entry,
    },
    lsp_references = {
      entry_maker = create_lsp_references_entry,
    },
    lsp_definitions = {
      entry_maker = create_lsp_definitions_entry,
    },
  },
}
telescope.load_extension 'fzf'
