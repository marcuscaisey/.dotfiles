local fn = vim.fn
local diagnostic = vim.lsp.diagnostic
local highlight = vim.highlight
local galaxyline = require 'galaxyline'
local condition = require 'galaxyline.condition'

galaxyline.short_line_list = { 'NvimTree' }

local mode_symbol_to_mode = {
  n = 'Normal',
  i = 'Insert',
  c = 'Command',
  v = 'Visual',
  V = 'Visual Line',
  [''] = 'Visual Block',
  R = 'Replace',
}

galaxyline.section.left = {
  {
    ViMode = {
      provider = function()
        local mode = mode_symbol_to_mode[fn.mode()]
        highlight.link('GalaxylineMode', 'Galaxyline' .. mode:gsub(' ', '') .. 'Mode', true)
        highlight.link('GalaxylineModeSeparator', 'Galaxyline' .. mode:gsub(' ', '') .. 'ModeSeparator', true)
        return '  ' .. mode .. ' '
      end,
      highlight = 'GalaxylineMode',
      separator = '',
      separator_highlight = 'GalaxylineModeSeparator',
    },
  },
  {
    GitIcon = {
      provider = function()
        return '  '
      end,
      condition = condition.check_git_workspace,
      highlight = 'DiffChange',
    },
  },
  {
    GitBranch = {
      provider = 'GitBranch',
      condition = condition.check_git_workspace,
    },
  },
  {
    Space = {
      provider = function()
        return ' '
      end,
      condition = condition.check_git_workspace,
    },
  },
  {
    DiffAdd = {
      provider = 'DiffAdd',
      condition = condition.check_git_workspace,
      icon = ' +',
      highlight = 'DiffAdd',
    },
  },
  {
    DiffModified = {
      provider = 'DiffModified',
      condition = condition.check_git_workspace,
      icon = ' ~',
      highlight = 'DiffChange',
    },
  },
  {
    DiffRemove = {
      provider = 'DiffRemove',
      condition = condition.check_git_workspace,
      icon = ' -',
      highlight = 'DiffDelete',
      separator = '',
    },
  },
  {
    Space = {
      provider = function()
        return ' '
      end,
    },
  },
  {
    FileIcon = {
      provider = 'FileIcon',
      condition = condition.buffer_not_empty,
      highlight = {
        require('galaxyline.providers.fileinfo').get_file_icon_color,
      },
    },
  },
  {
    FileName = {
      provider = 'FileName',
      condition = condition.buffer_not_empty,
      separator = '',
    },
  },
}

galaxyline.section.right = {
  {
    GetLspClient = {
      provider = 'GetLspClient',
      separator = ' ',
      condition = condition.check_active_lsp,
    },
  },
  {
    Space = {
      provider = function()
        return ' '
      end,
      condition = condition.check_active_lsp,
    },
  },
  {
    DiagnosticHint = {
      provider = function()
        return diagnostic.get_count(0, 'Hint')
      end,
      condition = condition.check_active_lsp,
      highlight = 'DiagnosticHint',
      icon = '  ',
    },
  },
  {
    DiagnosticWarn = {
      provider = function()
        return diagnostic.get_count(0, 'Warning')
      end,
      condition = condition.check_active_lsp,
      highlight = 'DiagnosticWarn',
      icon = '   ',
    },
  },
  {
    DiagnosticError = {
      provider = function()
        return diagnostic.get_count(0, 'Error')
      end,
      condition = condition.check_active_lsp,
      highlight = 'DiagnosticError',
      icon = '   ',
    },
  },
  {
    LineInfo = {
      provider = 'LineColumn',
      separator = '  ',
    },
  },
  {
    PerCent = {
      provider = 'LinePercent',
      highlight = 'GalaxylineNormalMode',
      separator = '',
      separator_highlight = 'GalaxylineNormalModeSeparator',
    },
  },
}
