local conflict = require('git-conflict')

conflict.setup({
  default_mappings = true,
  disable_diagnostics = true,
  highlights = {
    current = 'GitConflictCurrent',
    incoming = 'GitConflictIncoming',
    ancestor = 'GitConflictAncestor',
  },
})

vim.keymap.set('n', '<leader>cc', function() -- current changes
  conflict.choose('ours')
end)
vim.keymap.set('n', '<leader>ic', function() -- incoming changes
  conflict.choose('theirs')
end)
