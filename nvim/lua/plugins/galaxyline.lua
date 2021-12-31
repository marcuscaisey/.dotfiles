local fn = vim.fn
local diagnostic = vim.lsp.diagnostic
local galaxyline = require 'galaxyline'
local condition = require 'galaxyline.condition'
local colours = require 'colours'

galaxyline.short_line_list = { 'NvimTree' }

local mode_symbol_to_label_colour = {
  n = { 'Normal', colours.palette.purple },
  i = { 'Insert', colours.palette.green },
  c = { 'Command', colours.palette.cyan },
  v = { 'Visual', colours.palette.orange },
  V = { 'Visual Line', colours.palette.orange },
  [''] = { 'Visual Block', colours.palette.orange },
  R = { 'Replace', colours.palette.red },
}

local function mode_label()
  return mode_symbol_to_label_colour[fn.mode()][1]
end

local function mode_colour()
  return mode_symbol_to_label_colour[fn.mode()][2]
end

local function highlight(group, fg, bg, gui)
  local cmd = string.format('highlight %s guifg=%s guibg=%s', group, fg, bg)
  if gui ~= nil then
    cmd = cmd .. ' gui=' .. gui
  end
  vim.cmd(cmd)
end

galaxyline.section.left = {
  {
    ViMode = {
      provider = function()
        local colour = mode_colour()
        highlight('GalaxylineMode', colours.palette.bg, colour)
        highlight('GalaxylineModeSeparator', colour, colours.palette.bg)
        return '  ' .. mode_label() .. ' '
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
