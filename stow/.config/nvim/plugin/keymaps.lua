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
    local rhs ---@type function?
    if keymap.rhs then
      function rhs()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keymap.rhs, true, true, true), 'n', false)
      end
    elseif keymap.callback then
      rhs = keymap.callback
    end
    if rhs then
      vim.keymap.set('n', keymap.lhs, function()
        rhs()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('zz', true, true, true), 'n', false)
      end, { desc = string.format('%s + zz', keymap.desc) })
    end
  end
end

vim.keymap.set('n', '<leader>re', '<Cmd>mksession! /tmp/session.vim | restart +wqa source /tmp/session.vim<CR>')
