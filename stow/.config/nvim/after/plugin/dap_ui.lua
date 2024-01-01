local ok, dap = pcall(require, 'dap')
if not ok then
  return
end
local ok, dapui = pcall(require, 'dapui')
if not ok then
  return
end

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

---@diagnostic disable-next-line: missing-fields
dapui.setup({
  ---@diagnostic disable-next-line: missing-fields
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
})
