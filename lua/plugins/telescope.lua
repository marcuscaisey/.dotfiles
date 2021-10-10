local telescope = require 'telescope'
local entry_display = require 'telescope.pickers.entry_display'
local utils = require 'telescope.utils'
local fn = vim.fn

-- splits a filepath into head / tail where tail is the last path component and
-- head is everything before it. if tail is in the current working directory,
-- then head is relative. the home directory is replaced by ~ in head.
local function split_path(path)
  local tail = utils.path_tail(path)
  local head = path:gsub("/" .. tail .. "$", "")

  local cwd = fn.getcwd()
  if head == cwd then
    return "", tail
  end

  head = head:gsub("^" .. cwd .. "/", "")
  head = head:gsub("^" .. os.getenv("HOME"), "~")
  return head, tail
end

-- copied and modified from make_entry.gen_from_quickfix
local function make_lsp_definitions_entry(entry)
  local displayer = entry_display.create{
    separator = " ",
    items = {
      { remaining = true },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    local head, tail = split_path(entry.filename)
    return displayer{
      tail,
      {head, "TelescopeResultsLineNr"},
    }
  end

  return {
    valid = true,
    value = entry,
    ordinal = entry.filename .. " " .. entry.text,
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

-- copied and modified from make_entry.gen_from_quickfix
local function make_lsp_references_entry(entry)
  local displayer = entry_display.create{
    separator = " ",
    items = {
      { remaining = true },
      { remaining = true },
    },
  }

  local make_display = function(entry)
    local head, tail = split_path(entry.filename)

    local position = table.concat({ entry.lnum, entry.col }, ":")
    local tail_with_position = table.concat({tail, position}, ":")

    return displayer{
      tail_with_position,
      {head, "TelescopeResultsLineNr"},
    }
  end

  return {
    valid = true,
    value = entry,
    ordinal = entry.filename .. " " .. entry.text,
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

telescope.setup {
  defaults = {
    layout_config = {
      horizontal = {
        width = 0.9,
      },
      vertical = {
        width = 0.9,
      },
    },
    prompt_prefix = ' 🔍  ',
    selection_caret = '  ',
  },
  pickers = {
    find_files = {
      sorting_strategy = "ascending",
      layout_config = {
        preview_width = 0.4,
      },
    },
    buffers = {
      sorting_strategy = "ascending",
      layout_config = {
        preview_width = 0.4,
      },
      sort_lastused = true,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        },
        n = {
          ["<c-d>"] = "delete_buffer",
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
      sorting_strategy = 'ascending',
    },
    lsp_document_symbols = {
      layout_strategy = 'vertical',
      layout_config = {
        mirror = true,
      },
      sorting_strategy = "ascending",
    },
    lsp_references = {
      entry_maker = make_lsp_references_entry,
      layout_config = {
        preview_width = 0.5,
      },
    },
    lsp_definitions = {
      layout_config = {
        preview_width = 0.5,
      },
      entry_maker = make_lsp_definitions_entry,
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
