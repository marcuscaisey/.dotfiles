local g = vim.g
local fn = vim.fn
local galaxyline = require 'galaxyline'
local condition = require 'galaxyline.condition'
local lsp_client = require 'galaxyline.providers.lsp'
local diagnostic = vim.lsp.diagnostic

galaxyline.short_line_list = {
  'NvimTree',
}

local colours = {
  black    = g['dracula_pro#palette'].bg[1],
  gray     = g['dracula_pro#palette'].selection[1],
  white    = g['dracula_pro#palette'].fg[1],
  darkblue = g['dracula_pro#palette'].comment[1],
  cyan     = g['dracula_pro#palette'].cyan[1],
  green    = g['dracula_pro#palette'].green[1],
  orange   = g['dracula_pro#palette'].orange[1],
  purple   = g['dracula_pro#palette'].purple[1],
  red      = g['dracula_pro#palette'].red[1],
  yellow   = g['dracula_pro#palette'].yellow[1],

  bg       = g['dracula_pro#palette'].bg[1],
  fg       = g['dracula_pro#palette'].fg[1],
}

local mode_symbol_to_label_colour = {
  n = {'Normal', colours.purple},
  i = {'Insert', colours.green},
  c = {'Command', colours.cyan},
  v = {'Visual', colours.orange},
  V = {'Visual Line', colours.orange},
  [''] = {'Visual Block', colours.orange},
  R = {'Replace', colours.red},
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
        highlight('GalaxylineMode', colours.bg, colour)
        highlight('GalaxylineModeSeparator', colour, colours.bg)
        return '  ' .. mode_label() .. ' '
      end,
      highlight = 'GalaxylineMode',
      separator = '',
      separator_highlight = 'GalaxylineModeSeparator',
    },
  },
  {
    GitIcon = {
      provider = function() return '  ' end,
      condition = condition.check_git_workspace,
      highlight = {colours.orange, colours.bg},
    },
  },
  {
    GitBranch = {
      provider = 'GitBranch',
      condition = condition.check_git_workspace,
      highlight = {colours.fg, colours.bg},
    },
  },
  {
    Space = {
      provider = function() return ' ' end,
      condition = condition.check_git_workspace,
    },
  },
  {
    DiffAdd = {
      provider = 'DiffAdd',
      condition = condition.check_git_workspace,
      icon = ' +',
      highlight = {colours.green, colours.bg},
    },
  },
  {
    DiffModified = {
      provider = 'DiffModified',
      condition = condition.check_git_workspace,
      icon = ' ~',
      highlight = {colours.orange, colours.bg},
    },
  },
  {
    DiffRemove = {
      provider = 'DiffRemove',
      condition = condition.check_git_workspace,
      icon = ' -',
      highlight = {colours.red, colours.bg},
      separator = '',
      separator_highlight = {colours.fg, colours.bg},
    },
  },
  {
    Space = {
      provider = function() return ' ' end,
    },
  },
  {
    FileIcon = {
      provider = 'FileIcon',
      condition = condition.buffer_not_empty,
      highlight = {require('galaxyline.providers.fileinfo').get_file_icon_color, colours.bg},
    },
  },
  {
    FileName = {
      provider = 'FileName',
      condition = condition.buffer_not_empty,
      highlight = {colours.fg, colours.bg},
      separator = '',
      separator_highlight = {colours.fg, colours.bg},
    },
  },
}

galaxyline.section.right = {
  {
    DiagnosticHint = {
      provider = function() return diagnostic.get_count(0, 'Hint') end,
      condition = condition.check_active_lsp,
      highlight = 'LspDiagnosticsHint',
      icon = '  ',
      separator = '',
    },
  },
  {
    DiagnosticWarn = {
      provider = function() return diagnostic.get_count(0, 'Warning') end,
      condition = condition.check_active_lsp,
      highlight = 'LspDiagnosticsWarning',
      icon = '   ',
    },
  },
  {
    DiagnosticError = {
      provider = function() return diagnostic.get_count(0, 'Error') end,
      condition = condition.check_active_lsp,
      highlight = 'LspDiagnosticsError',
      icon = '   ',
    },
  },
  {
    LineInfo = {
      provider = 'LineColumn',
      highlight = {colours.cyan, colours.bg},
      separator = '  ',
    },
  },
  {
    PerCent = {
      provider = 'LinePercent',
      highlight = {colours.bg, colours.purple},
      separator = '',
      separator_highlight = {colours.purple, colours.bg},
    },
  },
}
