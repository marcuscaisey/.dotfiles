local cmp = require 'cmp'
local o = vim.o
local fn = vim.fn
local api = vim.api

o.completeopt = "menu,menuone,noselect"
o.shortmess = o.shortmess .. 'c'

local function replace_termcodes(s)
  return api.nvim_replace_termcodes(s, false, false, true)
end

local function feedkeys(keys, mode)
  api.nvim_feedkeys(replace_termcodes(keys), mode, true)
end

-- Check if we should tab out of a pair of brackets / quotes. Returns true if
-- the next character is a:
-- - closing bracket
-- - quote and we're inside a pair of them
local function should_tab_out()
  local brackets = {
    [')'] = true,
    [']'] = true,
    ['}'] = true,
  }
  local quotes = {
    ["'"] = true,
    ['"'] = true,
    ['`'] = true
  }

  local line = fn.getline('.')
  local col = fn.col('.')
  local next_char = line:sub(col, col)

  if quotes[next_char] then
    local preceding_chars = line:sub(1, col - 1)
    num_preceding_quotes = select(2, preceding_chars:gsub(next_char, ''))
    -- if odd number of preceding quotes, then we're currently inside a pair
    return num_preceding_quotes % 2 == 1
  end
  return brackets[next_char] == true
end

cmp.setup {
  sources = {
    {name = 'nvim_lsp'},
  },
  snippet = {
    expand = function(args)
      fn['vsnip#anonymous'](args.body)
    end,
  },
  mapping = {
    ['<c-space>'] = cmp.mapping.complete(),
    ['<tab>'] = function(fallback)
      if cmp.visible() then
        cmp.close()
      elseif should_tab_out() then
        feedkeys('<right>', 'i')
      else
        fallback()
      end
    end,
    ['<cr>'] = cmp.mapping.confirm({select = true, behavior = cmp.ConfirmBehavior.Replace}),
  },
  formatting = {
    format = require('lspkind').cmp_format(),
  },
}

require('nvim-autopairs.completion.cmp').setup({
  map_complete = true,
})
