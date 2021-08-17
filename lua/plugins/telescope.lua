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
      layout_strategy = 'vertical',
      layout_config = {
        mirror = true,
      },
      sorting_strategy = "ascending",
      previewer = false,
    },
    buffers = {
      layout_strategy = 'vertical',
      layout_config = {
        mirror = true,
      },
      sorting_strategy = "ascending",
      sort_lastused = true,
      mappings = {
        i = {
          ["<c-d>"] = "delete_buffer",
        },
        n = {
          ["<c-d>"] = "delete_buffer",
        },
      },
      previewer = false,
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
