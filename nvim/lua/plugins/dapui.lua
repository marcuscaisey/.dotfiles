local dap = require 'dap'
local dapui = require 'dapui'

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

dapui.setup {
  icons = { expanded = '▾', collapsed = '▸' },
  mappings = {
    expand = { 'h', 'l' },
    open = 'o',
    remove = 'd',
    edit = 'e',
    repl = 'r',
    toggle = 't',
  },
  layouts = {
    {
      elements = { 'scopes', 'breakpoints', 'stacks', 'watches' },
      size = 40,
      position = 'left',
    },
    {
      elements = { 'repl' },
      size = 0.25,
      position = 'bottom',
    },
  },
}
