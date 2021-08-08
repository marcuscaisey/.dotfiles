local cmd = vim.cmd

cmd('autocmd FileType sql setlocal commentstring=--%s')
