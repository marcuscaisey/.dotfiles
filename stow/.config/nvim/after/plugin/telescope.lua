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
  local path_without_home = path:gsub('^' .. os.getenv('HOME'), '~')
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

telescope.setup({
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
      layout_config = {
        width = 0.6,
        height = 0.9,
      },
      previewer = false,
      find_command = { 'fd', '--type', 'f', '--strip-cwd-prefix', '--follow', '--hidden', '--exclude', '.git' },
    },
    oldfiles = {
      layout_config = {
        width = 0.6,
        height = 0.9,
      },
      previewer = false,
      cwd_only = true,
      path_display = function(_, path)
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
      layout_config = {
        preview_width = 0.4,
      },
    },
    lsp_document_symbols = {
      entry_maker = function(entry)
        local displayer = entry_display.create({
          separator = ' ',
          items = {
            { width = 13 }, -- symbol type
            { remaining = true }, -- symbol name
          },
        })

        local make_display = function(entry)
          return displayer({
            { entry.symbol_type, 'CmpItemKind' .. entry.symbol_type },
            entry.symbol_name,
          })
        end

        return {
          valid = true,
          value = entry,
          ordinal = entry.text,
          display = make_display,
          filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr),
          lnum = entry.lnum,
          col = entry.col,
          symbol_name = entry.text:match('%[.+%]%s+(.*)'),
          symbol_type = entry.kind,
          start = entry.start,
          finish = entry.finish,
        }
      end,
    },
    lsp_dynamic_workspace_symbols = {
      entry_maker = function(entry)
        local displayer = entry_display.create({
          separator = ' ',
          items = {
            { width = 13 }, -- symbol type
            { remaining = true }, -- symbol name
            { remaining = true }, -- filepath
          },
        })

        local make_display = function(entry)
          return displayer({
            { entry.symbol_type, 'CmpItemKind' .. entry.symbol_type },
            entry.symbol_name,
            { shorten_path(entry.filename), 'TelescopeResultsLineNr' },
          })
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
      end,
    },
    lsp_references = {
      entry_maker = function(entry)
        local displayer = entry_display.create({
          separator = ' ',
          items = {
            { remaining = true }, -- filename
            { remaining = true }, -- line:col
            { remaining = true }, -- directory
          },
        })

        local make_display = function(entry)
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
      end,
    },
    lsp_implementations = {
      entry_maker = function(entry)
        local displayer = entry_display.create({
          separator = ' ',
          items = {
            { remaining = true }, -- filename
            { remaining = true }, -- line:col
            { remaining = true }, -- directory
          },
        })

        local make_display = function(entry)
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
      end,
    },
    lsp_definitions = {
      entry_maker = function(entry)
        local displayer = entry_display.create({
          separator = ' ',
          items = {
            { remaining = true }, -- filename
            { remaining = true }, -- directory
          },
        })

        local make_display = function(entry)
          local head = vim.fs.dirname(entry.filename)
          local tail = vim.fs.basename(entry.filename)
          head = shorten_path(head)
          return displayer({
            tail,
            { head, 'TelescopeResultsLineNr' },
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
      end,
    },
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

vim.keymap.set('n', '<c-p>', builtin.find_files)
vim.keymap.set('n', '<c-b>', builtin.buffers)
vim.keymap.set('n', '<c-g>', builtin.live_grep)
vim.keymap.set('n', '<leader>ht', builtin.help_tags)
vim.keymap.set('n', '<leader>of', builtin.oldfiles)
vim.keymap.set('n', '<leader>oaf', function()
  builtin.oldfiles({ cwd_only = false })
end)
vim.keymap.set('n', '<leader>tt', builtin.builtin)
vim.keymap.set('n', '<leader>tr', builtin.resume)
vim.keymap.set('n', '<leader>od', telescope.extensions.olddirs.picker)
vim.keymap.set('n', '<c-s>', builtin.lsp_document_symbols)
vim.keymap.set('n', '<leader>ss', builtin.lsp_dynamic_workspace_symbols)
vim.keymap.set('n', 'gd', builtin.lsp_definitions)
vim.keymap.set('n', 'gi', builtin.lsp_implementations)
vim.keymap.set('n', 'gr', function()
  builtin.lsp_references({ jump_type = 'never', include_current_line = true })
end)
