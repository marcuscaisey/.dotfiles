vim.keymap.set('i', 'jj', '<Esc>')

vim.keymap.set('n', '<C-W><', '<C-W>5<')
vim.keymap.set('n', '<C-W>>', '<C-W>5>')
vim.keymap.set('n', '<C-W>-', '<C-W>5-')
vim.keymap.set('n', '<C-W>+', '<C-W>5+')

vim.keymap.set('n', 'j', [[(v:count > 1 ? "m'" . v:count : "") . 'j']], { expr = true })
vim.keymap.set('n', 'k', [[(v:count > 1 ? "m'" . v:count : "") . 'k']], { expr = true })

vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

local quickfix_loclist_mappings = { '[q', ']q', '[Q', ']Q', '[<C-Q>', ']<C-Q>', '[l', ']l', '[l', ']l', '[<C-L>', ']<C-L>' }
for _, keymap in ipairs(vim.api.nvim_get_keymap('n')) do
  if vim.list_contains(quickfix_loclist_mappings, keymap.lhs) then
    local rhs ---@type (function|string)?
    local desc = keymap.desc
    if keymap.rhs then
      rhs = keymap.rhs .. 'zz'
    elseif keymap.callback then
      rhs = function()
        keymap.callback()
        vim.cmd.normal('zz')
      end
      desc = string.format('%s zz', keymap.desc)
    end
    if rhs then
      vim.keymap.set('n', keymap.lhs, rhs, { desc = desc })
    end
  end
end

vim.keymap.set('n', '<leader>re', '<Cmd>mksession! /tmp/session.vim | restart +wqa source /tmp/session.vim<CR>')
