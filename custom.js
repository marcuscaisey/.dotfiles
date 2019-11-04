// Configure CodeMirror Keymap
require([
    'nbextensions/vim_binding/vim_binding',   // depends your installation
], function() {
    CodeMirror.Vim.map("jj", "<Esc>", "insert")

    CodeMirror.Vim.map("gk", "gg", "normal")
    CodeMirror.Vim.map("gk", "gg", "visual")
    CodeMirror.Vim.map("gj", "G", "normal")
    CodeMirror.Vim.map("gj", "G", "visual")
    CodeMirror.Vim.map("gh", "^", "normal")
    CodeMirror.Vim.map("gh", "^", "visual")
    CodeMirror.Vim.map("gl", "$", "normal")
    CodeMirror.Vim.map("gl", "$", "visual")

    CodeMirror.Vim.map("Y", "y$", "normal")

    CodeMirror.Vim.map("II", "<Esc>I", "insert")
    CodeMirror.Vim.map("AA", "<Esc>A", "insert")
    CodeMirror.Vim.map("CC", "<Esc><Right>C", "insert")
    CodeMirror.Vim.map("DD", "<Esc><Right>D", "insert")
});

