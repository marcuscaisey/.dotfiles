local dap = require('dap')
local repl = require('dap.repl')
local ui = require('dap.ui')

-- evaluates an expression in the same way that nvim-dap does except it replaces literal \n and \t with actual newlines
-- and tabs
local print_literal = function(text)
  dap.session():evaluate(text, function(err, resp)
    if err then
      repl.append(err.message)
      return
    end
    local layer = ui.layer(vim.api.nvim_get_current_buf())
    local attributes = (resp.presentationHint or {}).attributes or {}
    if resp.variablesReference > 0 or vim.tbl_contains(attributes, 'rawString') then
      local tree = ui.new_tree(require('dap.entity').variable.tree_spec)
      tree.render(layer, resp)
    else
      local formatted_result = resp.result:gsub('\\n', '\n')
      formatted_result = formatted_result:gsub('\\t', '\t')
      layer.render(vim.split(formatted_result, '\n', { trimempty = true }))
    end
  end)
end

repl.commands = vim.tbl_extend('force', repl.commands, {
  custom_commands = {
    print = print_literal,
    p = print_literal,
  },
})

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint' })
vim.fn.sign_define('DapStopped', { text = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpointRejected' })

vim.keymap.set('n', '<leader>bp', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>bcp', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end)
vim.keymap.set('n', '<f5>', dap.continue)
vim.keymap.set('n', '<f17>', dap.terminate)
vim.keymap.set('n', '<f6>', dap.restart)
vim.keymap.set('n', '<f8>', dap.run_to_cursor)
vim.keymap.set('n', '<f10>', dap.step_over)
vim.keymap.set('n', '<f11>', function()
  dap.step_into({ askForTargets = true })
end)
vim.keymap.set('n', '<f23>', dap.step_out)
