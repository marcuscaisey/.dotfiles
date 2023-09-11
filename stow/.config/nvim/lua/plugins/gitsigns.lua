local gitsigns = require('gitsigns')
local actions = require('gitsigns.actions')

gitsigns.setup({
  numhl = true,
  preview_config = {
    border = 'none',
    relative = 'cursor',
  },
  on_attach = function(bufnr)
    vim.keymap.set('n', ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      actions.next_hunk({
        wrap = false,
        navigation_message = true,
      })
      return '<Ignore>'
    end, { buffer = bufnr, expr = true })
    vim.keymap.set('n', '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      actions.prev_hunk({
        wrap = false,
        navigation_message = true,
      })
      return '<Ignore>'
    end, { buffer = bufnr, expr = true })
    vim.keymap.set('n', '<leader>hs', actions.stage_hunk, { buffer = bufnr })
    vim.keymap.set('v', '<leader>hs', function()
      actions.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { buffer = bufnr })
    vim.keymap.set('n', '<leader>hS', actions.stage_buffer, { buffer = bufnr })
    vim.keymap.set('n', '<leader>hu', actions.undo_stage_hunk, { buffer = bufnr })
    vim.keymap.set('n', '<leader>hr', actions.reset_hunk, { buffer = bufnr })
    vim.keymap.set('v', '<leader>hr', function()
      actions.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, { buffer = bufnr })
    vim.keymap.set('n', '<leader>hR', actions.reset_buffer, { buffer = bufnr })
    vim.keymap.set('n', '<leader>hp', actions.preview_hunk_inline, { buffer = bufnr })
    vim.keymap.set('n', '<leader>gc', function()
      actions.setqflist('all', { open = true })
    end, { buffer = bufnr })
  end,
})
