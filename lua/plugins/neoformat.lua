local g = vim.g
local cmd = vim.cmd
g.neoformat_enabled_python = {'black'}

-- Autoformat go files on save
cmd([[autocmd BufWritePre *.go Neoformat gofmt]])

-- Organise go imports on save
cmd([[autocmd BufWritePre *.go Neoformat goimports]])
