local M = {}

local augroup = vim.api.nvim_create_augroup('filetypes', { clear = true })

M.setup = function(opts)
  for filetype, cfg in pairs(opts) do
    if cfg.tab_size then
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          vim.bo.tabstop = cfg.tab_size
          vim.bo.shiftwidth = cfg.tab_size
        end,
        pattern = filetype,
        group = augroup,
        desc = string.format('Use %d space tabs', cfg.tab_size),
      })
    end

    if cfg.text_width then
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          vim.bo.textwidth = cfg.text_width
          vim.opt_local.formatoptions = vim.opt_local.formatoptions - { 'o' }
          if not cfg.auto_wrap then
            vim.opt_local.formatoptions = vim.opt_local.formatoptions - { 't' }
          end
        end,
        pattern = filetype,
        group = augroup,
        desc = string.format('Use %d textwidth', cfg.text_width),
      })
    end

    if cfg.indent_with_tabs then
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          vim.bo.expandtab = false
        end,
        pattern = filetype,
        group = augroup,
        desc = 'Indent with tabs',
      })
    end
  end
end

return M
