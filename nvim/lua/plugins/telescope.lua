local telescope = require 'telescope'
local layout = require 'telescope.actions.layout'
local entry_display = require 'telescope.pickers.entry_display'
local utils = require 'telescope.utils'
local codicons = require 'codicons'
local fn = vim.fn

-- splits a filepath into head / tail where tail is the last path component and
-- head is everything before it. if tail is in the current working directory,
-- then head is relative. the home directory is replaced by ~ in head.
local function split_path(path)
  local tail = utils.path_tail(path)
  local head = path:gsub('/' .. tail .. '$', '')

  local cwd = fn.getcwd()
  if head == cwd then return '', tail end

  head = head:gsub('^' .. cwd .. '/', '')
  head = head:gsub('^' .. os.getenv('HOME'), '~')
  return head, tail
end

-- copied and modified from make_entry.gen_from_quickfix
local function make_lsp_definitions_entry(entry)
  local displayer = entry_display.create {
    separator = ' ',
    items = {{remaining = true}, {remaining = true}}
  }

  local make_display = function(entry)
    local head, tail = split_path(entry.filename)
    return displayer {tail, {head, 'TelescopeResultsLineNr'}}
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
    finish = entry.finish
  }
end

-- copied and modified from make_entry.gen_from_quickfix
local function make_lsp_references_entry(entry)
  local displayer = entry_display.create {
    separator = ' ',
    items = {{remaining = true}, {remaining = true}}
  }

  local make_display = function(entry)
    local head, tail = split_path(entry.filename)

    local position = table.concat({entry.lnum, entry.col}, ':')
    local tail_with_position = table.concat({tail, position}, ':')

    return displayer {tail_with_position, {head, 'TelescopeResultsLineNr'}}
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
    finish = entry.finish
  }
end

local lsp_type_highlight = {
  ['Class'] = 'TelescopeResultsClass',
  ['Constant'] = 'TelescopeResultsConstant',
  ['Field'] = 'TelescopeResultsField',
  ['Function'] = 'TelescopeResultsFunction',
  ['Method'] = 'TelescopeResultsMethod',
  ['Property'] = 'TelescopeResultsOperator',
  ['Struct'] = 'TelescopeResultsStruct',
  ['Variable'] = 'TelescopeResultsVariable'
}

-- copied and modified from make_entry.gen_from_lsp_symbols
local function make_lsp_document_symbols_entry(entry)
  local displayer = entry_display.create {
    separator = ' ',
    items = {
      {remaining = true}, -- symbol type icon
      {remaining = true} -- symbol
    }
  }

  local make_display = function(entry)
    local icon = codicons.get('symbol-' .. entry.symbol_type:lower())
    return displayer {
      {
        icon, lsp_type_highlight[entry.symbol_type],
        lsp_type_highlight[entry.symbol_type]
      }, entry.symbol_name
    }
  end

  local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)
  local symbol_msg = entry.text:gsub('.* | ', '')
  local symbol_type, symbol_name = symbol_msg:match '%[(.+)%]%s+(.*)'
  local ordinal = symbol_name .. ' ' .. (symbol_type or 'unknown')

  return {
    valid = true,
    value = entry,
    ordinal = ordinal,
    display = make_display,
    filename = filename,
    lnum = entry.lnum,
    col = entry.col,
    symbol_name = symbol_name,
    symbol_type = symbol_type,
    start = entry.start,
    finish = entry.finish
  }
end

telescope.setup {
  defaults = {
    layout_config = {
      horizontal = {width = 0.9, prompt_position = 'top', preview_width = 0.5},
      vertical = {width = 0.9}
    },
    mappings = {
      i = {['<c-h>'] = layout.toggle_preview},
      n = {['<c-h>'] = layout.toggle_preview}
    },
    sorting_strategy = 'ascending',
    prompt_prefix = ' 🔍  ',
    selection_caret = '  '
  },
  pickers = {
    find_files = {
      layout_config = {preview_width = 0.4},
      find_command = {'fd', '--type', 'f', '--strip-cwd-prefix'}
    },
    buffers = {
      layout_config = {preview_width = 0.4},
      sort_lastused = true,
      mappings = {
        i = {['<c-d>'] = 'delete_buffer'},
        n = {['<c-d>'] = 'delete_buffer'}
      }
    },
    live_grep = {layout_config = {preview_width = 0.4}},
    current_buffer_fuzzy_find = {previewer = false},
    lsp_document_symbols = {entry_maker = make_lsp_document_symbols_entry},
    lsp_references = {entry_maker = make_lsp_references_entry},
    lsp_definitions = {entry_maker = make_lsp_definitions_entry}
  }
}
telescope.load_extension('fzf')
