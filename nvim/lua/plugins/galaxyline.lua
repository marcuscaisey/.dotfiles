local fn = vim.fn
local diagnostic = vim.lsp.diagnostic
local highlight = vim.highlight
local galaxyline = require 'galaxyline'
local condition = require 'galaxyline.condition'
local colours = require 'colours'

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
      highlight = { colours.palette.orange, colours.palette.bg },
    },
  },
  {
    GitBranch = {
      provider = 'GitBranch',
      condition = condition.check_git_workspace,
      highlight = { colours.palette.fg, colours.palette.bg },
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
      highlight = { colours.palette.green, colours.palette.bg },
    },
  },
  {
    DiffModified = {
      provider = 'DiffModified',
      condition = condition.check_git_workspace,
      icon = ' ~',
      highlight = { colours.palette.orange, colours.palette.bg },
    },
  },
  {
    DiffRemove = {
      provider = 'DiffRemove',
      condition = condition.check_git_workspace,
      icon = ' -',
      highlight = { colours.palette.red, colours.palette.bg },
      separator = '',
      separator_highlight = { colours.palette.fg, colours.palette.bg },
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
        colours.palette.bg,
      },
    },
  },
  {
    FileName = {
      provider = 'FileName',
      condition = condition.buffer_not_empty,
      highlight = { colours.palette.fg, colours.palette.bg },
      separator = '',
      separator_highlight = { colours.palette.fg, colours.palette.bg },
    },
  },
}

galaxyline.section.right = {
  {
    DiagnosticHint = {
      provider = function()
        return diagnostic.get_count(0, 'Hint')
      end,
      condition = condition.check_active_lsp,
      highlight = 'LspDiagnosticsHint',
      icon = '  ',
      separator = '',
    },
  },
  {
    DiagnosticWarn = {
      provider = function()
        return diagnostic.get_count(0, 'Warning')
      end,
      condition = condition.check_active_lsp,
      highlight = 'LspDiagnosticsWarning',
      icon = '   ',
    },
  },
  {
    DiagnosticError = {
      provider = function()
        return diagnostic.get_count(0, 'Error')
      end,
      condition = condition.check_active_lsp,
      highlight = 'LspDiagnosticsError',
      icon = '   ',
    },
  },
  {
    LineInfo = {
      provider = 'LineColumn',
      highlight = { colours.palette.cyan, colours.palette.bg },
      separator = '  ',
    },
  },
  {
    PerCent = {
      provider = 'LinePercent',
      highlight = { colours.palette.bg, colours.palette.purple },
      separator = '',
      separator_highlight = { colours.palette.purple, colours.palette.bg },
    },
  },
}
