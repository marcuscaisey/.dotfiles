local context = require('treesitter-context')
local configs = require('nvim-treesitter.configs')
local tsutils = require('nvim-treesitter.ts_utils')

configs.setup({
  ensure_installed = {
    'comment',
    'git_rebase',
    'gitcommit',
    'go',
    'html',
    'java',
    'javascript',
    'json',
    'php',
    'proto',
    'sql',
    'regex',
    'ruby',
    'scheme',
    'yaml',
  },
  highlight = {
    enable = true,
    disable = { 'yaml' },
  },
  indent = { enable = false },
  textobjects = {
    select = {
      enable = true,
      lookahead = false,
      keymaps = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ia'] = '@parameter.inner',
        ['aa'] = '@parameter.outer',
        ['ic'] = '@call.inner',
        ['ac'] = '@call.outer',
        ['iC'] = '@class.inner',
        ['aC'] = '@class.outer',
        ['iv'] = '@value.inner',
        ['av'] = '@value.outer',
      },
      selection_modes = {
        ['@function.outer'] = 'V',
        ['@function.inner'] = 'V',
        ['@class.outer'] = 'V',
        ['@class.inner'] = 'V',
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        [']f'] = '@function.outer',
        [']a'] = '@parameter.inner',
        [']m'] = '@method.outer',
      },
      goto_next_end = {
        [']F'] = '@function.outer',
        [']M'] = '@method.outer',
      },
      goto_previous_start = {
        ['[f'] = '@function.outer',
        ['[a'] = '@parameter.inner',
        ['[m'] = '@method.outer',
      },
      goto_previous_end = {
        ['[F'] = '@function.outer',
        ['[M'] = '@method.outer',
      },
    },
  },
  playground = {
    enable = true,
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { 'BufWrite', 'CursorHold' },
  },
  autotag = {
    enable = true,
    enable_close = true,
    enable_rename = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
})

context.setup()

-- jump past closing pair character with <c-l>
local closing_chars = { "'", '"', '`', '}', ')', ']' }
vim.keymap.set('i', '<c-l>', function()
  -- first check if the next character is a closing pair character
  local next_col = vim.fn.col('.')
  local next_char = vim.fn.getline('.'):sub(next_col, next_col)
  if vim.tbl_contains(closing_chars, next_char) then
    local jump_pos = { vim.fn.line('.'), next_col }
    vim.api.nvim_win_set_cursor(0, jump_pos)
    return
  end

  -- fallback to looking for closing pair character at the end of treesitter node under cursor
  local node = vim.treesitter.get_node()
  if not node then
    return
  end
  local node_text = vim.treesitter.get_node_text(node, 0)
  local last_char = node_text:sub(#node_text)
  if vim.tbl_contains(closing_chars, last_char) then
    local node_end_line, node_end_col = tsutils.get_vim_range({ node:end_() })
    local last_buf_line, last_buf_col = vim.fn.line('$'), vim.fn.col('$')
    if node_end_line <= last_buf_line and node_end_col <= last_buf_col then
      local jump_pos = { node_end_line, node_end_col - 1 } -- cursor col is 0-indexed
      vim.api.nvim_win_set_cursor(0, jump_pos)
    end
  end
end)
