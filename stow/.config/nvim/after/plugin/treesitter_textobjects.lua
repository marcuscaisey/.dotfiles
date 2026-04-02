local ok, treesitter_textobjects = pcall(require, 'nvim-treesitter-textobjects')
if not ok then
    return
end

treesitter_textobjects.setup({
    select = {
        lookahead = true,
        selection_modes = {
            ['@function.outer'] = 'V',
            ['@function.inner'] = 'V',
        },
        include_surrounding_whitespace = function(args)
            return args.query_string == '@function.outer'
        end,
    },
})

-- stylua: ignore start
vim.keymap.set({ 'x', 'o' }, 'af', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")<CR>', { desc = 'Select inside function' })
vim.keymap.set({ 'x', 'o' }, 'if', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")<CR>', { desc = 'Select around function' })
vim.keymap.set({ 'n', 'x', 'o' }, ']]', '<Cmd>lua require("nvim-treesitter-textobjects.move").goto_next_start("@section.outer", "textobjects")<CR>', { desc = 'Jump to start of next section' })
vim.keymap.set({ 'n', 'x', 'o' }, '][', '<Cmd>lua require("nvim-treesitter-textobjects.move").goto_next_end("@section.outer", "textobjects")<CR>', { desc = 'Jump to end of next sections' })
vim.keymap.set({ 'n', 'x', 'o' }, '[[', '<Cmd>lua require("nvim-treesitter-textobjects.move").goto_previous_start("@section.outer", "textobjects")<CR>', { desc = 'Jump to start of previous section' })
vim.keymap.set({ 'n', 'x', 'o' }, '[]', '<Cmd>lua require("nvim-treesitter-textobjects.move").goto_previous_end("@section.outer", "textobjects")<CR>', { desc = 'Jump to end of previous section' })
vim.keymap.set({ 'x', 'o' }, 'ia', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")<CR>', { desc = 'Select inside parameter' })
vim.keymap.set({ 'x', 'o' }, 'aa', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")<CR>', { desc = 'Select around parameter' })
vim.keymap.set({ 'x', 'o' }, 'ac', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@call.outer", "textobjects")<CR>', { desc = 'Select around call' })
vim.keymap.set({ 'x', 'o' }, 'ib', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@block.inner", "textobjects")<CR>', { desc = 'Select inside block' })
vim.keymap.set({ 'x', 'o' }, 'ab', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@block.outer", "textobjects")<CR>', { desc = 'Select around block' })
-- stylua: ignore end
