local telescope = require 'telescope'
local layout = require 'telescope.actions.layout'
local entry_display = require 'telescope.pickers.entry_display'
local utils = require 'telescope.utils'
local lsp_utils = require 'lsp_utils'
local fn = vim.fn

--- Splits a filepath into head / tail where tail is the last path component and
--- head is everything before it. If tail is in the current working directory,
--- then head is relative. The home directory is replaced by ~ in head.
--- @param path string Path to split
--- @return string head
--- @return string tail
local function split_path(path)
  local tail = utils.path_tail(path)
  local head = path:gsub('/' .. tail .. '$', '')

  local cwd = fn.getcwd()
  if head == cwd then
    return '', tail
  end

  head = head:gsub('^' .. cwd .. '/', '')
  head = head:gsub('^' .. os.getenv 'HOME', '~')
  return head, tail
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
      },
    },
    sorting_strategy = 'ascending',
    prompt_prefix = ' 🔍  ',
    selection_caret = '  ',
  },
  pickers = {
    find_files = {
      layout_config = {
        preview_width = 0.4,
      },
      find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix', '--follow', '--hidden', '--exclude', '.git' },
    },
    buffers = {
      layout_config = {
        preview_width = 0.4,
      },
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
      -- copied and modified from make_entry.gen_from_lsp_symbols
      entry_maker = function(entry)
        local displayer = entry_display.create {
          separator = ' ',
          items = {
            { remaining = true }, -- symbol type icon
            { remaining = true }, -- symbol
          },
        }

        local make_display = function(entry)
          return displayer {
            {
              lsp_utils.symbol_codicon(entry.symbol_type),
              'LSPSymbolKind' .. entry.symbol_type,
            },
            entry.symbol_name,
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
          finish = entry.finish,
        }
      end,
    },
    lsp_references = {
      -- copied and modified from make_entry.gen_from_quickfix
      entry_maker = function(entry)
        local displayer = entry_display.create {
          separator = ' ',
          items = {
            { remaining = true },
            { remaining = true },
          },
        }

        local make_display = function(entry)
          local head, tail = split_path(entry.filename)

          local position = table.concat({ entry.lnum, entry.col }, ':')
          local tail_with_position = table.concat({ tail, position }, ':')

          return displayer {
            tail_with_position,
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
      end,
    },
    lsp_definitions = {
      -- copied and modified from make_entry.gen_from_quickfix
      entry_maker = function(entry)
        local displayer = entry_display.create {
          separator = ' ',
          items = {
            { remaining = true },
            { remaining = true },
          },
        }

        local make_display = function(entry)
          local head, tail = split_path(entry.filename)
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
      end,
    },
  },
}
telescope.load_extension 'fzf'
