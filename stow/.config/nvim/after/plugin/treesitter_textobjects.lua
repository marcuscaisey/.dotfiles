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
    },
})

-- stylua: ignore start
vim.keymap.set({ 'x', 'o' }, 'af', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")<CR>')
vim.keymap.set({ 'x', 'o' }, 'if', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")<CR>')
vim.keymap.set({ 'x', 'o' }, ']f', '<Cmd>lua require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")<CR>')
vim.keymap.set({ 'x', 'o' }, '[f', '<Cmd>lua require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")<CR>')
vim.keymap.set({ 'x', 'o' }, 'ia', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")<CR>')
vim.keymap.set({ 'x', 'o' }, 'aa', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")<CR>')
vim.keymap.set({ 'x', 'o' }, ']a', '<Cmd>lua require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner", "textobjects")<CR>')
vim.keymap.set({ 'x', 'o' }, '[a', '<Cmd>lua require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner", "textobjects")<CR>')
vim.keymap.set({ 'x', 'o' }, 'ic', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@call.inner", "textobjects")<CR>')
vim.keymap.set({ 'x', 'o' }, 'ac', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@call.outer", "textobjects")<CR>')
vim.keymap.set({ 'x', 'o' }, 'ib', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@block.inner", "textobjects")<CR>')
vim.keymap.set({ 'x', 'o' }, 'ab', '<Cmd>lua require("nvim-treesitter-textobjects.select").select_textobject("@block.outer", "textobjects")<CR>')
-- stylua: ignore end
