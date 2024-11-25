local protocol = require('vim.lsp.protocol')

local augroup = vim.api.nvim_create_augroup('lsp', { clear = true })

---@param item lsp.CompletionItem
---@return string
local function item_documentation(item)
  local lines = {}

  if item.detail and item.detail ~= '' then
    table.insert(lines, vim.trim(item.detail))
  end

  local documentation = item.documentation
  if type(documentation) == 'string' and documentation ~= '' then
    local value = vim.trim(documentation)
    if value ~= '' then
      table.insert(lines, value)
    end
  elseif type(documentation) == 'table' and documentation.value then
    local value = vim.trim(documentation.value)
    if value ~= '' then
      table.insert(lines, value)
    end
  end

  return table.concat(lines, '\n')
end

---@param item lsp.CompletionItem
---@return table
local function completion_item_to_vim_item(item)
  return {
    menu = '',
    info = item_documentation(item),
    kind_hlgroup = string.format('LspItemKind%s', protocol.CompletionItemKind[item.kind] or ''),
  }
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup,
  desc = 'Create codelens autocmd and enable completion',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if client.supports_method(protocol.Methods.textDocument_codeLens) then
      vim.api.nvim_create_autocmd({ 'BufEnter', 'InsertLeave', 'BufWritePost', 'CursorHold' }, {
        callback = function()
          vim.lsp.codelens.refresh({ bufnr = args.buf })
        end,
        group = augroup,
        buffer = args.buf,
        desc = 'Refresh codelenses automatically',
      })
    end

    if client.supports_method(protocol.Methods.textDocument_completion) then
      vim.lsp.completion.enable(
        true,
        client.id,
        args.buf,
        { autotrigger = true, convert = completion_item_to_vim_item }
      )
    end
  end,
})

-- Format JSON-RPC messages as JSON
vim.lsp.log.set_format_func(function(...)
  return vim.inspect(..., {
    newline = '',
    process = function(item, _)
      if type(item) == 'table' and item.jsonrpc then
        return vim.json.encode(item)
      else
        return item
      end
    end,
  })
end)
if vim.env.NVIM_DISABLE_LSP_LOGGING == 'true' then
  vim.lsp.set_log_level(vim.log.levels.OFF)
end
if vim.env.NVIM_LSP_LOG_LEVEL then
  vim.lsp.set_log_level(vim.env.NVIM_LSP_LOG_LEVEL)
end

vim.keymap.set('n', 'grl', vim.lsp.codelens.run, { desc = 'vim.lsp.codelens.run()' })
