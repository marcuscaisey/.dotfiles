local dap = require('dap')
local entity = require('dap.entity')
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
      local tree = ui.new_tree(entity.variable.tree_spec)
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
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped' })
vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpointRejected' })

vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>dcb', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end)
vim.keymap.set({ 'n', 'i' }, '<f5>', dap.continue)
vim.keymap.set({ 'n', 'i' }, '<f17>', dap.terminate)
vim.keymap.set({ 'n', 'i' }, '<f6>', dap.restart)
vim.keymap.set('n', '<f8>', dap.run_to_cursor)
vim.keymap.set({ 'n', 'i' }, '<f10>', dap.step_over)
vim.keymap.set({ 'n', 'i' }, '<f11>', function()
  dap.step_into({ askForTargets = true })
end)
vim.keymap.set({ 'n', 'i' }, '<f23>', dap.step_out)

dap.adapters.delve = {
  type = 'server',
  port = '${port}',
  executable = {
    command = 'dlv',
    args = { 'dap', '-l', '127.0.0.1:${port}' },
  },
}

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = 'delve',
    request = 'launch',
    name = 'Debug',
    mode = 'debug',
    program = '${file}',
  },
  {
    type = 'delve',
    request = 'launch',
    name = 'Debug test',
    mode = 'test',
    program = '${file}',
  },
}
