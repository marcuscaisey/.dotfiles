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
      local result = vim.system({ 'git', 'diff', '--quiet' }):wait()
      if result.code == 0 then
        print('No Git changes')
        vim.cmd.cclose()
        return
      end

      vim.fn.setqflist({})
      gitsigns.setqflist('all', { open = false })
      -- wait for quickfix list to have items in before opening
      vim.wait(5000, function()
        local qf_items = vim.fn.getqflist()
        return #qf_items > 0
      end, 10)
      vim.cmd.copen()
      vim.cmd.cfirst()
    end, { buffer = bufnr })
  end,
})
