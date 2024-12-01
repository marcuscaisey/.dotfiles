local ok, dap = pcall(require, 'dap')
if not ok then
  return
end

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped' })
vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DapBreakpointRejected' })

vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint, { desc = 'dap.toggle_breakpoint()' })
vim.keymap.set('n', '<Leader>dcb', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'dap.set_breakpoint()' })
vim.keymap.set({ 'n', 'i' }, '<F5>', dap.continue, { desc = 'dap.continue()' })
vim.keymap.set({ 'n', 'i' }, '<F17>', dap.terminate, { desc = 'dap.terminate()' })
vim.keymap.set({ 'n', 'i' }, '<F6>', dap.restart, { desc = 'dap.restart()' })
vim.keymap.set('n', '<F8>', dap.run_to_cursor, { desc = 'dap.run_to_cursor()' })
vim.keymap.set({ 'n', 'i' }, '<F10>', dap.step_over, { desc = 'dap.step_over()' })
vim.keymap.set({ 'n', 'i' }, '<F11>', function()
  dap.step_into({ askForTargets = true })
end, { desc = 'dap.step_into({ askForTargets = true })' })
vim.keymap.set({ 'n', 'i' }, '<F23>', dap.step_out, { desc = 'dap.step_out()' })

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

dap.adapters.debugpy = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

-- https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
dap.configurations.python = {
  {
    type = 'debugpy',
    request = 'launch',
    name = 'Debug',
    program = '${file}',
  },
}
