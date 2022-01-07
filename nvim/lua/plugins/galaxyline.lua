local fn = vim.fn
local diagnostic = vim.diagnostic
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

local function both(a, b)
  return function()
    return a() and b()
  end
end

local function diagnostics_count(severity)
  local diagnostics = diagnostic.get(0, { severity = severity })
  local count = 0
  for _ in pairs(diagnostics) do
    count = count + 1
  end
  return count
end

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
      condition = both(condition.check_git_workspace, condition.hide_in_width),
      highlight = 'DiffChange',
    },
  },
  {
    GitBranch = {
      provider = 'GitBranch',
      condition = both(condition.check_git_workspace, condition.hide_in_width),
    },
  },
  {
    Space = {
      provider = function()
        return ' '
      end,
      condition = both(condition.check_git_workspace, condition.hide_in_width),
    },
  },
  {
    DiffAdd = {
      provider = 'DiffAdd',
      condition = both(condition.check_git_workspace, condition.hide_in_width),
      icon = ' +',
      highlight = 'DiffAdd',
    },
  },
  {
    DiffModified = {
      provider = 'DiffModified',
      condition = both(condition.check_git_workspace, condition.hide_in_width),
      icon = ' ~',
      highlight = 'DiffChange',
    },
  },
  {
    DiffRemove = {
      provider = 'DiffRemove',
      condition = both(condition.check_git_workspace, condition.hide_in_width),
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
      condition = condition.hide_in_width,
      separator = ' ',
    },
  },
  {
    Space = {
      provider = function()
        return ' '
      end,
      condition = condition.hide_in_width,
    },
  },
  {
    DiagnosticHint = {
      provider = function()
        return diagnostics_count(diagnostic.severity.HINT) + diagnostics_count(diagnostic.severity.INFO)
      end,
      condition = condition.hide_in_width,
      highlight = 'DiagnosticHint',
      icon = '  ',
    },
  },
  {
    DiagnosticWarn = {
      provider = function()
        return diagnostics_count(diagnostic.severity.WARN)
      end,
      condition = condition.hide_in_width,
      highlight = 'DiagnosticWarn',
      icon = '   ',
    },
  },
  {
    DiagnosticError = {
      provider = function()
        return diagnostics_count(diagnostic.severity.ERROR)
      end,
      condition = condition.hide_in_width,
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
