local telescope = require 'telescope'
local layout = require 'telescope.actions.layout'
local entry_display = require 'telescope.pickers.entry_display'
local utils = require 'telescope.utils'
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

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
      { remaining = true }, -- symbol type
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

-- copied from telescope.actions.set.edit
local function edit(entry)
  if not entry then
    print '[telescope] Nothing currently selected'
    return
  end

  local filename, row, col

  if entry.path or entry.filename then
    filename = entry.path or entry.filename
    row = entry.row or entry.lnum
    col = entry.col
  elseif not entry.bufnr then
    local value = entry.value
    if not value then
      print 'Could not do anything with blank line...'
      return
    end

    if type(value) == 'table' then
      value = entry.display
    end

    local sections = vim.split(value, ':')

    filename = sections[1]
    row = tonumber(sections[2])
    col = tonumber(sections[3])
  end

  local entry_bufnr = entry.bufnr

  if entry_bufnr then
    if not vim.api.nvim_buf_get_option(entry_bufnr, 'buflisted') then
      vim.api.nvim_buf_set_option(entry_bufnr, 'buflisted', true)
    end
    local ok, err_msg = pcall(vim.cmd, 'buffer ' .. entry_bufnr)
    if not ok then
      print(string.format('Failed to open buffer %d: %s', entry_bufnr, err_msg))
    end
  else
    -- check if we didn't pick a different buffer
    -- prevents restarting lsp server
    if vim.api.nvim_buf_get_name(0) ~= filename then
      local ok, err_msg = pcall(vim.cmd, 'edit ' .. filename)
      if not ok then
        print(string.format('Failed to open %s: %s', filename, err_msg))
      end
    end
  end

  if row and col then
    local ok, err_msg = pcall(vim.api.nvim_win_set_cursor, 0, { row, col })
    if not ok then
      print(string.format('Failed to move to cursor to %d:%d: %s', row, col, err_msg))
    end
  end
end

local function multi_open(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local selections = picker:get_multi_selection()

  actions.close(prompt_bufnr)

  if #selections == 0 then
    return edit(action_state.get_selected_entry())
  end

  for _, entry in ipairs(selections) do
    edit(entry)
  end
end

telescope.setup {
  defaults = {
    layout_config = {
      horizontal = {
        width = 0.9,
        prompt_position = 'top',
        preview_width = 0.5,
      },
      vertical = { width = 0.9 },
    },
    mappings = {
      i = {
        ['<c-h>'] = layout.toggle_preview,
      },
      n = {
        ['<c-h>'] = layout.toggle_preview,
        ['<c-c>'] = actions.close,
        ['<c-n>'] = actions.move_selection_next,
        ['<c-p>'] = actions.move_selection_previous,
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
        preview_width = 0.4,
      },
      mappings = {
        i = {
          ['<cr>'] = multi_open,
        },
        n = {
          ['<cr>'] = multi_open,
        },
      },
      find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix', '--follow', '--hidden', '--exclude', '.git' },
    },
    oldfiles = {
      layout_config = {
        preview_width = 0.4,
      },
      mappings = {
        i = {
          ['<cr>'] = multi_open,
        },
        n = {
          ['<cr>'] = multi_open,
        },
      },
      path_display = function(opts, path)
        return shorten_path(path)
      end,
    },
    buffers = {
      layout_config = {
        preview_width = 0.4,
      },
      sort_mru = true,
      ignore_current_buffer = true,
      mappings = {
        i = {
          ['<cr>'] = multi_open,
          ['<c-d>'] = 'delete_buffer',
        },
        n = {
          ['<cr>'] = multi_open,
          ['<c-d>'] = 'delete_buffer',
        },
      },
    },
    live_grep = {
      layout_config = {
        preview_width = 0.4,
      },
      mappings = {
        i = {
          ['<cr>'] = multi_open,
        },
        n = {
          ['<cr>'] = multi_open,
        },
      },
    },
    current_buffer_fuzzy_find = {
      previewer = false,
    },
    lsp_document_symbols = {
      entry_maker = create_lsp_document_symbols_entry,
      mappings = {
        i = {
          ['<cr>'] = multi_open,
        },
        n = {
          ['<cr>'] = multi_open,
        },
      },
    },
    lsp_references = {
      entry_maker = create_lsp_references_entry,
      mappings = {
        i = {
          ['<cr>'] = multi_open,
        },
        n = {
          ['<cr>'] = multi_open,
        },
      },
    },
    lsp_definitions = {
      entry_maker = create_lsp_definitions_entry,
      mappings = {
        i = {
          ['<cr>'] = multi_open,
        },
        n = {
          ['<cr>'] = multi_open,
        },
      },
    },
  },
}
telescope.load_extension 'fzf'
