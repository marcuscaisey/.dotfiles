local cmd = vim.cmd

cmd('autocmd FileType sql setlocal commentstring=--%s')
cmd([[autocmd FileType toml setlocal commentstring=#%s]])
