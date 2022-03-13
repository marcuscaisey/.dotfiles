local augroup = vim.api.nvim_create_augroup('per_file_type_settings', { clear = true })

local function add_tab_size_autocmd(file_type, tab_size)
  vim.api.nvim_create_autocmd('FileType', {
    callback = function()
      vim.bo.tabstop = tab_size
      vim.bo.shiftwidth = tab_size
    end,
    pattern = file_type,
    group = augroup,
    desc = string.format('Use %d space tabs', tab_size),
  })
end

local function add_text_width_autocmd(file_type, text_width)
  vim.api.nvim_create_autocmd('FileType', {
    callback = function()
      vim.bo.textwidth = text_width
      vim.cmd 'setlocal formatoptions-=o'
    end,
    pattern = file_type,
    group = augroup,
    desc = string.format('Use %d textwidth', text_width),
  })
end

local function add_indent_with_tabs_autocmd(file_type)
  vim.api.nvim_create_autocmd('FileType', {
    callback = function()
      vim.bo.expandtab = false
    end,
    pattern = file_type,
    group = augroup,
    desc = 'Indent with tabs',
  })
end

local function setup(opts)
  for file_type, settings in pairs(opts) do
    if settings.tab_size then
      add_tab_size_autocmd(file_type, settings.tab_size)
    end
    if settings.text_width then
      add_text_width_autocmd(file_type, settings.text_width)
    end
    if settings.indent_with_tabs then
      add_indent_with_tabs_autocmd(file_type)
    end
  end
end

return {
  setup = setup,
}
