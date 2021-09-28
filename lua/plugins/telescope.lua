local telescope = require 'telescope'

telescope.setup {
  defaults = {
    layout_config = {
      horizontal = {
        preview_width = 0.6,
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
      layout_strategy = 'vertical',
      layout_config = {
        mirror = true,
      },
      sorting_strategy = "ascending",
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
