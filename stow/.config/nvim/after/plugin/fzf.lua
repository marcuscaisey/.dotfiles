local ok, fzf = pcall(require, 'fzf-lua')
if not ok then
  return
end
local olddirs_exists, olddirs = pcall(require, 'olddirs')

fzf.setup({
  defaults = {
    copen = 'copen | cfirst',
    fzf_opts = {
      ['--cycle'] = true,
    },
  },
  keymap = {
    fzf = {
      true,
      ['ctrl-q'] = 'select-all+accept',
    },
  },
  actions = {
    files = {
      true,
      -- Default alt-f mapping clobbers the one provided by fzf to jump to the next word.
      ['alt-f'] = false,
    },
  },
  winopts = {
    width = 0.9,
    height = 0.9,
    ---@diagnostic disable-next-line: missing-fields
    preview = {
      horizontal = 'right:50%',
    },
  },
  files = {
    fd_opts = '--strip-cwd-prefix ' .. fzf.defaults.files.fd_opts,
    follow = true,
  },
  grep = {
    rg_opts = '--glob=!.git ' .. fzf.defaults.grep.rg_opts,
    hidden = true,
    follow = true,
  },
  helptags = {
    -- Omit help file name
    fzf_opts = vim.tbl_extend('force', fzf.defaults.fzf_opts, {
      ['--delimiter'] = '\\s+',
      ['--with-nth'] = '1',
    }),
  },
  lsp = {
    jump1 = false, -- Show the UI when result is a single entry.
    symbols = {
      symbol_style = 3, -- Omit kind icon
      symbol_hl = function(s)
        return 'LspItemKind' .. s
      end,
      -- Default format surrounds symbol in []
      symbol_fmt = function(s)
        return s
      end,
      -- Omit line and column
      fzf_opts = vim.tbl_extend('force', fzf.defaults.lsp.document_symbols.fzf_opts, {
        ['--delimiter'] = '\\t\\t',
        ['--with-nth'] = '2..',
      }),
    },
  },
  oldfiles = {
    cwd_only = true,
    winopts = {
      title = ' Oldfiles (cwd only) ',
    },
    actions = {
      ['alt-c'] = {
        fn = function(_, opts)
          opts.__call_fn(vim.tbl_deep_extend('keep', {
            resume = true,
            cwd_only = not opts.cwd_only,
            winopts = { title = ' Oldfiles ' .. (opts.cwd_only and '(all) ' or '(cwd only) ') },
          }, opts.__call_opts or {}))
        end,
        desc = 'toggle-cwd-only',
        reuse = true,
      },
    },
  },
  olddirs = {
    git_repo_only = true,
  },
  ui_select = true,
})

vim.keymap.set('n', '<C-P>', fzf.files, { desc = 'fzf.files()' })
vim.keymap.set('n', '<C-\\>', fzf.buffers, { desc = 'fzf.buffers()' })
vim.keymap.set('n', '<C-G>', fzf.live_grep, { desc = 'fzf.live_grep()' })
vim.keymap.set('n', '<F1>', fzf.help_tags, { desc = 'fzf.help_tags()' })
vim.keymap.set('n', '<C-K>', fzf.oldfiles, { desc = 'fzf.oldfiles()' })
if olddirs_exists then
  vim.keymap.set('n', '<C-J>', olddirs.fzf_picker, { desc = 'olddirs.fzf_picker' })
end
vim.keymap.set('n', '<Leader>zz', fzf.builtin, { desc = 'fzf.builtin()' })
vim.keymap.set('n', '<Leader>zr', fzf.resume, { desc = 'fzf.resume()' })
vim.keymap.set('n', 'gO', fzf.lsp_document_symbols, { desc = 'fzf.lsp_document_symbols()' })
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('fzf_lsp_definitions_mappings', {}),
  desc = 'Add mappings for fzf.lsp_definitions if the client supports it',
  ---@param args vim.api.keyset.create_autocmd.callback_args
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/definition') then
      vim.keymap.set('n', 'g]', fzf.lsp_definitions, { buffer = args.buf, desc = 'fzf.lsp_definitions()' })
      vim.keymap.set('n', 'g<C-]>', function()
        fzf.lsp_definitions({ jump1 = true })
      end, { buffer = args.buf, desc = 'fzf.lsp_definitions({ jump1 = true })' })
    end
  end,
})
vim.keymap.set('n', 'grr', fzf.lsp_references, { desc = 'fzf.lsp_references()' })
vim.keymap.set('n', 'gri', fzf.lsp_implementations, { desc = 'fzf.lsp_implementations()' })
