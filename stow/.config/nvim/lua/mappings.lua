local ls = require('luasnip')
local tsutils = require('nvim-treesitter.ts_utils')
local telescope_builtin = require('telescope.builtin')
local telescope_state = require('telescope.actions.state')
local telescope_actions = require('telescope.actions')
local gitsigns = require('gitsigns.actions')
local harpoon_ui = require('harpoon.ui')
local conflict = require('git-conflict')
local dap = require('dap')
local Job = require('plenary.job')

vim.keymap.set('i', 'jj', '<esc>')

vim.keymap.set('n', 'gk', 'gg')
vim.keymap.set('v', 'gk', 'gg')
vim.keymap.set('n', 'gj', 'G')
vim.keymap.set('v', 'gj', 'G')
vim.keymap.set('n', 'gh', '^')
vim.keymap.set('v', 'gh', '^')
vim.keymap.set('n', 'gl', '$')
vim.keymap.set('v', 'gl', 'g_')

vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-w>j', '<c-w>J')
vim.keymap.set('n', '<c-w>k', '<c-w>K')
vim.keymap.set('n', '<c-w>l', '<c-w>L')
vim.keymap.set('n', '<c-w>h', '<c-w>H')
vim.keymap.set('n', '<c-w><', '<c-w>5<')
vim.keymap.set('n', '<c-w>>', '<c-w>5>')
vim.keymap.set('n', '<c-w>-', '<c-w>5-')
vim.keymap.set('n', '<c-w>=', '<c-w>5+')
vim.keymap.set('n', '<c-w>e', '<c-w>=')

vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')
vim.keymap.set('n', '<c-d>', '<c-d>zz')
vim.keymap.set('n', '<c-u>', '<c-u>zz')

vim.keymap.set('i', 'II', '<esc>I')
vim.keymap.set('i', 'AA', '<esc>A')

vim.keymap.set('t', '<esc>', '<c-\\><c-n>')

-- When i use map to create this, nothing appears in the command line when i trigger the mapping until i press another
-- key. Not sure why...
vim.cmd('vnoremap @ :norm @')

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
  local node = tsutils.get_node_at_cursor()
  local node_text = table.concat(tsutils.get_node_text(node))
  local last_char = node_text:sub(#node_text)
  if vim.tbl_contains(closing_chars, last_char) then
    local node_end_line, node_end_col = tsutils.get_vim_range({ node:end_() })
    local last_buf_line, last_buf_col = vim.fn.line('$'), vim.fn.col('$')
    if node_end_line <= last_buf_line and node_end_col <= last_buf_col then
      local jump_pos = { node_end_line, node_end_col - 1 } -- cursor col is 0-indexed
      vim.api.nvim_win_set_cursor(0, jump_pos)
      return
    end
  end
end)

local qf_delete_undo_stack = {}

-- delete a quickfix item
vim.keymap.set('n', 'dd', function()
  if vim.o.filetype ~= 'qf' then
    vim.api.nvim_feedkeys('dd', 'n', true)
    return
  end

  local qf_items = vim.fn.getqflist()
  if #qf_items == 0 then
    return
  end

  local cursor_line, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
  local removed_item = table.remove(qf_items, cursor_line)
  table.insert(qf_delete_undo_stack, { cursor_line, cursor_col, removed_item })

  local next_item = qf_items[cursor_line]
  if next_item then
    local next_item_winnr = vim.fn.bufwinnr(next_item.bufnr)
    local next_item_winid = vim.fn.win_getid(next_item_winnr)
    vim.api.nvim_win_call(next_item_winid, function()
      vim.api.nvim_win_set_cursor(0, { next_item.lnum, next_item.col - 1 })
    end)
  end

  vim.fn.setqflist({}, 'r', { idx = cursor_line, items = qf_items })

  if #qf_items > 0 then
    if cursor_line <= #qf_items then
      vim.api.nvim_win_set_cursor(0, { cursor_line, cursor_col })
    else
      vim.api.nvim_win_set_cursor(0, { cursor_line - 1, cursor_col })
    end
  end
end)

-- undo deleting a quickfix item
vim.keymap.set('n', 'u', function()
  if vim.o.filetype ~= 'qf' then
    vim.api.nvim_feedkeys('u', 'n', true)
    return
  end

  if #qf_delete_undo_stack == 0 then
    return
  end

  local qf_items = vim.fn.getqflist()
  local cursor_line, cursor_col, removed_item = unpack(table.remove(qf_delete_undo_stack))
  table.insert(qf_items, cursor_line, removed_item)

  vim.fn.setqflist(qf_items)

  vim.api.nvim_win_set_cursor(0, { cursor_line, cursor_col })
end)

-- toggle quickfix
vim.keymap.set('n', '<leader>q', function()
  local qf_window_id = vim.fn.getqflist({ winid = 0 }).winid
  -- window id > 0 means that the window is open
  local qf_open = qf_window_id > 0
  if qf_open then
    vim.cmd('cclose')
  else
    vim.cmd('copen')
  end
end)

-- open changed buffers in quickfix
vim.keymap.set('n', '<leader>cb', function()
  -- filter buffers for changed property since bufmodified = 1 doesn't seem to filter out all unchanged buffers
  local changed_buffers = vim.tbl_filter(
    function(b)
      return b.changed == 1
    end,
    vim.fn.getbufinfo({
      bufmodified = 1,
    })
  )
  if #changed_buffers == 0 then
    print('no changed buffers')
    return
  end
  vim.fn.setqflist(changed_buffers)
  vim.cmd('copen')
  vim.cmd('cfirst')
end)

-- telescope.nvim
-- Pick new working directory for the current window. Picks from directory inside the current git repo if available,
-- otherwise the current directory.
vim.keymap.set('n', '<leader>cd', function()
  local cwd = vim.trim(vim.fn.system('git rev-parse --show-toplevel'))
  if vim.v.shell_error > 0 then
    cwd = vim.fn.getcwd()
  end

  local change_cwd = function(prompt_bufnr)
    local entry = telescope_state.get_selected_entry()
    telescope_actions.close(prompt_bufnr) -- need to close prompt first otherwise cwd of prompt gets set
    vim.api.nvim_cmd({ cmd = 'lcd', args = { entry.path } }, {})
    print(string.format('window cwd set to %s', entry[1]))
  end

  telescope_builtin.find_files({
    prompt_title = 'Change window working directory',
    find_command = { 'fd', '--type', 'd', '--strip-cwd-prefix' },
    cwd = cwd,
    previewer = false,
    attach_mappings = function(_, telescope_map)
      telescope_map('i', '<cr>', change_cwd)
      telescope_map('n', '<cr>', change_cwd)
      return true
    end,
  })
end)
vim.keymap.set('n', '<c-p>', telescope_builtin.find_files)
vim.keymap.set('n', '<c-b>', telescope_builtin.buffers)
vim.keymap.set('n', '<c-f>', telescope_builtin.current_buffer_fuzzy_find)
vim.keymap.set('n', '<c-g>', telescope_builtin.live_grep)
vim.keymap.set('n', '<c-s>', telescope_builtin.lsp_document_symbols)
vim.keymap.set('n', '<leader>s', telescope_builtin.lsp_dynamic_workspace_symbols)
vim.keymap.set('n', 'gd', telescope_builtin.lsp_definitions)
vim.keymap.set('n', 'gi', telescope_builtin.lsp_implementations)
vim.keymap.set('n', 'ge', telescope_builtin.lsp_references)
vim.keymap.set('n', '<leader>ht', telescope_builtin.help_tags)
vim.keymap.set('n', '<leader>of', telescope_builtin.oldfiles)
vim.keymap.set('n', '<leader>tt', telescope_builtin.builtin)
vim.keymap.set('n', '<leader>tr', telescope_builtin.resume)

-- lsp
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 'dK', vim.diagnostic.open_float)
vim.keymap.set('n', 'dr', vim.diagnostic.reset)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>rc', vim.lsp.codelens.run)
vim.keymap.set('n', ']e', function()
  vim.diagnostic.goto_next({ severity = { min = vim.diagnostic.severity.WARN } })
end)
vim.keymap.set('n', '[e', function()
  vim.diagnostic.goto_prev({ severity = { min = vim.diagnostic.severity.WARN } })
end)
vim.keymap.set('n', '<leader>dq', function()
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics == 0 then
    print('No diagnostics')
    vim.cmd('cclose')
    return
  end
  local qf_items = vim.diagnostic.toqflist(diagnostics)
  vim.fn.setqflist(qf_items)
  vim.cmd('copen')
  vim.cmd('cfirst')
end)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set('v', '<leader>ca', vim.lsp.buf.code_action)

-- neoformat
local wollemi = function()
  local plz_root = vim.fs.find('.plzconfig', { upwards = true })[1]
  if vim.bo.filetype ~= 'go' or not plz_root then
    return
  end
  local output_lines = {}
  local on_output = function(_, line)
    table.insert(output_lines, line)
  end
  local on_exit = function()
    print(table.concat(output_lines, '\n'))
  end
  local job = Job:new({
    command = 'wollemi',
    args = { 'gofmt' },
    -- run in the directory of the saved file since wollemi won't run outside of a plz repo
    cwd = vim.fn.expand('%:p:h'),
    env = {
      -- wollemi needs GOROOT to be set
      GOROOT = vim.trim(vim.fn.system('go env GOROOT')),
      PATH = vim.fn.getenv('PATH'),
    },
    on_stdout = on_output,
    on_stderr = on_output,
    on_exit = on_exit,
  })
  job:start()
end

vim.keymap.set('n', '<leader>fm', function()
  vim.cmd.Neoformat()
  wollemi()
end)

-- vim-fugitive
vim.keymap.set('n', '<leader>gb', '<cmd>:Git blame<cr>')

-- gitsigns.nvim
vim.keymap.set('n', ']c', gitsigns.next_hunk)
vim.keymap.set('n', '[c', gitsigns.prev_hunk)
vim.keymap.set({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer)
vim.keymap.set('n', '<leader>hu', gitsigns.undo_stage_hunk)
vim.keymap.set({ 'n', 'v' }, '<leader>hr', '<cmd>Gitsigns reset_hunk<cr>')
vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer)
vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk_inline)
vim.keymap.set('n', '<leader>hd', gitsigns.toggle_deleted)
vim.keymap.set({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
vim.keymap.set('n', '<leader>gc', function()
  vim.fn.system('git diff --quiet')
  if vim.v.shell_error == 0 then
    print('No Git changes')
    vim.cmd('cclose')
    return
  end

  vim.fn.setqflist({})
  gitsigns.setqflist('all', { open = false })
  -- wait for quickfix list to have items in before opening
  vim.wait(5000, function()
    local qf_items = vim.fn.getqflist()
    return #qf_items > 0
  end)
  vim.cmd('copen')
  vim.cmd('cfirst')
end)

-- harpoon
vim.keymap.set('n', '<leader>ha', require('harpoon.mark').add_file)
vim.keymap.set('n', '<leader>hh', harpoon_ui.toggle_quick_menu)
for n = 1, 4 do
  vim.keymap.set('n', string.format('<leader>%d', n), function()
    harpoon_ui.nav_file(n)
  end)
end

-- plenary
vim.keymap.set('n', '<leader>lt', '<Plug>PlenaryTestFile')

-- please.nvim
-- require all of these in a callback so that we can hot reload them
vim.keymap.set('n', '<leader>pj', function()
  require('please').jump_to_target()
end)
vim.keymap.set('n', '<leader>pb', function()
  require('please').build()
end)
vim.keymap.set('n', '<leader>pt', function()
  require('please').test()
end)
vim.keymap.set('n', '<leader>pct', function()
  require('please').test({ under_cursor = true })
end)
vim.keymap.set('n', '<leader>plt', function()
  require('please').test({ list = true })
end)
vim.keymap.set('n', '<leader>pft', function()
  require('please').test({ failed = true })
end)
vim.keymap.set('n', '<leader>pr', function()
  require('please').run()
end)
vim.keymap.set('n', '<leader>py', function()
  require('please').yank()
end)
vim.keymap.set('n', '<leader>pp', function()
  require('please.runners.popup').restore()
end)
vim.keymap.set('n', '<leader>pll', function()
  require('please.plugin').reload()
end)
vim.keymap.set('n', '<leader>pd', function()
  require('please').debug()
end)
vim.keymap.set('n', '<leader>pa', function()
  require('please').action_history()
end)

-- luasnip
vim.keymap.set({ 'i', 's' }, '<c-j>', function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end)
vim.keymap.set({ 'i', 's' }, '<c-k>', function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end)
vim.keymap.set({ 'i', 's' }, '<c-h>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)
vim.keymap.set('n', '<leader><leader>s', function()
  vim.cmd('source ~/.dotfiles/nvim/lua/plugins/luasnip.lua')
  print('reloaded snippets')
end)

-- git-conflict.nvim
vim.keymap.set('n', '<leader>cc', function() -- current changes
  conflict.choose('ours')
end)
vim.keymap.set('n', '<leader>ic', function() -- incoming changes
  conflict.choose('theirs')
end)

-- nvim-dap
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

-- Go
vim.keymap.set('n', '<leader>gt', function()
  if vim.bo.filetype ~= 'go' then
    print('not in a Go file')
    return
  end

  local filepath = vim.api.nvim_buf_get_name(0)
  local dirname = vim.fs.dirname(filepath)
  local basename = vim.fs.basename(filepath)

  local new_basename
  if basename:match('_test') then
    new_basename = basename:match('^(.+)_test%.go$') .. '.go'
  else
    new_basename = basename:match('^(.+)%.go$') .. '_test.go'
  end

  vim.cmd({ cmd = 'edit', args = { dirname .. '/' .. new_basename } })
end)

-- netrw
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'netrw',
  callback = function()
    -- there are other mappings in netrw starting with q which we don't care about, so don't wait for any more keys
    vim.keymap.set('n', 'q', '<c-^>', { nowait = true, buffer = true })
  end,
  group = vim.api.nvim_create_augroup('mappings', { clear = true }),
  desc = 'Map q to ctrl-^ in netrw',
})

local shell_cmd_or_die = function(cmd, ...)
  local output_or_err = vim.trim(vim.fn.system(string.format(cmd, ...)))
  if vim.v.shell_error > 0 then
    error(output_or_err)
  end
  return output_or_err
end

-- sourcegraph
vim.keymap.set('n', '<leader>ys', function()
  local url_template = 'https://sourcegraph.iap.tmachine.io/git.gaia.tmachine.io/diffusion/CORE@%s/-/blob/%s?L%d'
  local commit = shell_cmd_or_die('git rev-parse HEAD')
  local root = shell_cmd_or_die('git rev-parse --show-toplevel')
  local absolute_filepath = vim.api.nvim_buf_get_name(0)
  local relative_filepath = shell_cmd_or_die('realpath --relative-to %s %s', root, absolute_filepath)
  local line_num = unpack(vim.api.nvim_win_get_cursor(0))
  local url = url_template:format(commit, relative_filepath, line_num)
  for _, register in ipairs({ '"', '*' }) do
    vim.fn.setreg(register, url)
  end
  if vim.fn.exists(':OSCYankReg') == 2 then
    vim.cmd.OSCYankReg({ args = { '"' } })
  end
  print(string.format('Yanked %s', url))
end)
