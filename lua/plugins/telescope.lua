local telescope = require 'telescope'

telescope.setup {
  defaults = {
    layout_config = {
      horizontal = {
        preview_width = 0.6,
        width = 0.9,
      },
    },
    prompt_prefix = ' 🔍  ',
    selection_caret = '  ',
  },
  pickers = {
    current_buffer_fuzzy_find = {
      previewer = false,
      sorting_strategy = 'ascending',
    },
    lsp_document_symbols = {
      theme = 'dropdown',
    }
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
