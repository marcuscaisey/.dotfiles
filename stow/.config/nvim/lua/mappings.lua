local tsutils = require('nvim-treesitter.ts_utils')

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
