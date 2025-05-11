local languages = {
  javascript = { { formatCommand = 'prettierd ${INPUT}', formatStdin = true } },
  lua = { { formatCommand = 'stylua --stdin-filepath=${INPUT} -', formatStdin = true } },
  markdown = { { formatCommand = 'prettierd ${INPUT}', formatStdin = true } },
  python = { { formatCommand = 'black --stdin-filename=${INPUT} --quiet -', formatStdin = true } },
  typescript = { { formatCommand = 'prettierd ${INPUT}', formatStdin = true } },
}

---@type vim.lsp.Config
return {
  filetypes = vim.tbl_keys(languages),
  init_options = { documentFormatting = true },
  settings = { languages = languages },
}
