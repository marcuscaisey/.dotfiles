" ==============================================================================
"                                   vim-plug
" ==============================================================================
" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')
" Syntax
let g:polyglot_disabled = ['yaml', 'python']
Plug 'sheerun/vim-polyglot'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'shmup/vim-sql-syntax'

" UI
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'machakann/vim-highlightedyank'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'edkolev/tmuxline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'maximbaz/lightline-ale'

" Search
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

" Command
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-fugitive'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'vim-scripts/ReplaceWithRegister'

" Verb
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'

" Motion
Plug 'justinmk/vim-sneak'
Plug 'nelstrom/vim-visual-star-search'
Plug 'bkad/camelcasemotion'

" Text objects
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'tommcdo/vim-exchange'
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'Vimjas/vim-python-pep8-indent'

" Completion
Plug 'liuchengxu/vista.vim'
let g:ale_disable_lsp = 1
Plug 'dense-analysis/ale'

call plug#end()


" ==============================================================================
"                                   mappings
" ==============================================================================
let mapleader = " "

inoremap jj <esc>

nnoremap gk gg
vnoremap gk gg
nnoremap gj G
vnoremap gj G
nnoremap gh ^
vnoremap gh ^
nnoremap gl $
vnoremap gl g_

nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h
nnoremap <c-w>j <c-w>J
nnoremap <c-w>k <c-w>K
nnoremap <c-w>l <c-w>L
nnoremap <c-w>h <c-w>H

nnoremap Y y$

inoremap II <esc>I
inoremap AA <esc>A

" Tab closes the autocomplete menu and moves the cursor out of paired
" characters
let g:tab_out_chars = [')', ']', '}',  "'",  '"',  '`']
inoremap <silent> <expr> <tab> pumvisible()
  \ ? '<c-e>'
  \ : index(g:tab_out_chars, getline('.')[col('.') - 1]) != -1
  \ ? '<right>'
  \ : '<tab>'

nnoremap <silent> <leader>n :bn<cr>
nnoremap <silent> <leader>p :bp<cr>


" ==============================================================================
"                                   settings
" ==============================================================================
packadd dracula_pro
colorscheme dracula_pro
set clipboard=unnamed
set cursorline
set expandtab
set fileformat=unix
set hidden
set ignorecase
set mouse=a
set nohlsearch
set noshowmode
set noswapfile
set number
set scrolloff=5
set shiftwidth=4
set showtabline=2
set signcolumn=yes
set smartcase
set splitbelow
set splitright
set tabstop=4
set termguicolors
set updatetime=100


" =============================================================================
"                               plugin settings
" =============================================================================
" commentary.vim
autocmd FileType sql setlocal commentstring=--\ %s

" Lightline
let g:lightline = {
  \ 'colorscheme': 'dracula_pro',
  \ 'active': {
  \     'left': [
  \         ['mode', 'paste'],
  \         ['gitbranch', 'readonly', 'filename'],
  \     ],
  \     'right': [
  \         ['lineinfo'],
  \         ['percent'],
  \         ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos'],
  \     ],
  \ },
  \ 'tabline': {
  \     'left': [['buffers']],
  \     'right': [],
  \ },
  \ 'component_function': {
  \     'filename': 'LightlineFilename',
  \     'filetype': 'LightlineFiletype',
  \     'fileformat': 'LightlineFileformat',
  \     'encoding': 'LightlineEncoding',
  \ },
  \ 'component_expand': {
  \     'buffers': 'lightline#bufferline#buffers',
  \     'linter_checking': 'lightline#ale#checking',
  \     'linter_infos': 'lightline#ale#infos',
  \     'linter_warnings': 'lightline#ale#warnings',
  \     'linter_errors': 'lightline#ale#errors',
  \     'gitbranch': 'LightlineGitBranch',
  \ },
  \ 'component_type': {
  \     'buffers': 'tabsel',
  \     'linter_checking': 'right',
  \     'linter_infos': 'right',
  \     'linter_warnings': 'warning',
  \     'linter_errors': 'error',
  \ },
  \ 'component_raw': {'buffers': 1},
  \ 'separator': {'left': '', 'right': ''},
  \ 'subseparator': {'left': '', 'right': ''},
  \ }

let g:lightline#bufferline#enable_devicons = 1
let g:lightline#bufferline#unicode_symbols = 1
let g:lightline#bufferline#clickable = 1

let g:lightline#ale#indicator_checking = "\uf110 "
let g:lightline#ale#indicator_infos = "\uf129 "
let g:lightline#ale#indicator_warnings = "\uf071 "
let g:lightline#ale#indicator_errors = "\uf05e "

function! LightlineFilename()
    let filename = expand('%:t')
    let filename = filename != '' ? filename : '*'
    let modified = &modified ? ' ✎' : ''
    return WebDevIconsGetFileTypeSymbol() . ' ' . filename . modified
endfunction

function! LightlineFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? WebDevIconsGetFileTypeSymbol() . ' ' . &filetype : 'no ft') : ''
endfunction

function! LightlineFileformat()
    return winwidth(0) > 70 ? (WebDevIconsGetFileFormatSymbol() . ' ' . &fileformat) : ''
endfunction

function! LightlineEncoding()
    return winwidth(0) > 70 ? &encoding : ''
endfunction

function! LightlineGitBranch()
    let branch = fugitive#head()
    return branch != '' ? ' ' . branch : ''
endfunction

" tmuxline
let g:tmuxline_preset = {
  \ 'a': '#S',
  \ 'y': ['%Y-%m-%d', '%H:%M'],
  \ 'z': '#H',
  \ 'win': ['#I','#W'],
  \ 'cwin': ['#I','#W'],
  \ 'options': {'status-justify': 'left'},
  \ }

" vim-polyglot
let g:python_highlight_all = 1 " Enable all python syntax highlighting features

let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

" fzf.vim
nnoremap <silent> <c-p> :Files<cr>
nnoremap <silent> <c-b> :Buffers<cr>
nnoremap <silent> <c-g> :Rg<cr>

" vim-easy-align
nmap <silent> ga <Plug>(EasyAlign)
xmap <silent> ga <Plug>(EasyAlign)

" vim-sneak
highlight link Sneak IncSearch
let g:sneak#use_ic_scs = 1

" camelcasemotion
let g:camelcasemotion_key = '<leader>'

" vim-fugitive
nmap <silent> <expr> <leader>gb &filetype ==# 'fugitiveblame' ? 'gq' : ':Gblame<cr>'

" Semshi
let g:semshi#error_sign = 0

function PythonHighlights()
    highlight! link semshiGlobal DraculaGreen
    highlight! link semshiImported DraculaOrange
    highlight! link semshiParameter DraculaCyan
    highlight! link semshiParameterUnused DraculaLink
    highlight! link semshiFree DraculaPurple
    highlight! link semshiBuiltin DraculaPurple
    highlight! link semshiAttribute DraculaFgBold
    highlight! link semshiSelf DraculaPurple
    let yellow = g:dracula_pro#palette.yellow
    exec 'highlight! semshiUnresolved  cterm=undercurl ctermfg=' . yellow[1] . ' gui=undercurl guifg=' . yellow[0]
    highlight! link semshiSelected DraculaSelection
endfunction

" ALE
let g:ale_linters = {
  \ 'python': ['flake8', 'mypy'],
  \ }

let g:ale_fixers = {
  \ 'python': ['isort', 'black'],
  \ }

let g:ale_python_black_options = '--line-length 120'
let g:ale_python_flake8_options = '--max-line-length 120'
let g:ale_python_isort_options = '--line-length 120 --multi-line VERTICAL_HANGING_INDENT --trailing-comma'

noremap <silent> ]e :ALENextWrap<cr>
noremap <silent> [e :ALEPreviousWrap<cr>
noremap <silent> <leader>f :ALEFix<cr>


" =============================================================================
"                                    misc
" =============================================================================
" Jump to last position when opening a file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Trim trailing whitespace on write
autocmd BufWritePre * if expand('%:e') !=# 'diff' | %s/\s\+$//e | endif

" Use 2 space tabs for yaml,html,css,js,json files
autocmd FileType yaml,html*,css,javascript,json setlocal ts=2 sts=2 sw=2 expandtab

" Fix colours in tmux
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Set Python syntax highlighting colours
autocmd Filetype python call PythonHighlights()