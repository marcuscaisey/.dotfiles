require('git-conflict').setup {
  default_mappings = true,
  disable_diagnostics = true,
  highlights = {
    incoming = 'GitConflictIncoming',
    current = 'GitConflictCurrent',
  },
}
