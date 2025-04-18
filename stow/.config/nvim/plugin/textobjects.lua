vim.keymap.set({ 'o', 'v' }, 'ae', ':<C-U>execute "normal! gg" | keepjumps normal! VG<CR>', {
  desc = '"around everything" text object, selects everything in the buffer',
  silent = true,
})
