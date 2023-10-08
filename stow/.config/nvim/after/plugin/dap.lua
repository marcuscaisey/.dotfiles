local ok, dap = pcall(require, 'dap')
if not ok then
  return
end

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
    args = function()
      return coroutine.create(function(dap_run_co)
        vim.ui.input({ prompt = 'Enter program arguments' }, function(args)
          if not args then
            return
          end
          coroutine.resume(dap_run_co, vim.split(args, ' ', { trimempty = true }))
        end)
      end)
    end,
  },
  {
    type = 'delve',
    request = 'launch',
    name = 'Debug test',
    mode = 'test',
    program = '${file}',
  },
}
