" ==============================================================================
"                                   vim-plug
" ==============================================================================
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" Syntax
Plug 'sheerun/vim-polyglot'
Plug 'shmup/vim-sql-syntax'

" Theme
Plug 'joshdick/onedark.vim'

" UI
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'machakann/vim-highlightedyank'
Plug 'mengelbrecht/lightline-bufferline'
Plug 'ryanoasis/vim-devicons'

" Search
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

" Command
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'jiangmiao/auto-pairs'
Plug 'maralla/completor.vim'

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
inoremap CC <esc><right>C
inoremap DD <esc><right>D

" Tab closes the autocomplete menu and moves the cursor out of paired
" characters
let g:tab_out_chars = [')', ']', '}',  "'",  '"',  '`']
inoremap <silent> <expr> <tab> pumvisible()
  \ ? '<c-e>'
  \ : index(g:tab_out_chars, getline('.')[col('.') - 1]) != -1
  \ ? '<right>'
  \ : '<tab>'

" Enter commits the highlighted autocomplete suggestion
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"

nnoremap <leader>n :bn<cr>
nnoremap <leader>p :bp<cr>

nnoremap <silent> <leader>y :set paste!<cr>


" ==============================================================================
"                                   settings
" ==============================================================================
set number
set laststatus=2
set showtabline=2
set noshowmode
set incsearch
set nohlsearch
set showcmd
set splitbelow
set splitright
set signcolumn=yes
set cursorline
let g:onedark_termcolors=16
let g:onedark_terminal_italics=1
color onedark
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
syntax on
filetype plugin indent on
set autoindent
set fileformat=unix
set encoding=utf-8
set noswapfile
set hidden
set tabstop=4
set shiftwidth=4
set expandtab
set backspace=indent,eol,start
set clipboard=unnamed
set mouse=a
set scrolloff=5
set colorcolumn=80


" =============================================================================
"                               plugin settings
" =============================================================================
" commentary.vim
autocmd FileType sql setlocal commentstring=--\ %s

" Lightline
let g:lightline = {
  \ 'colorscheme': 'onedark',
  \ 'active': {
  \     'left': [
  \         ['mode', 'paste'],
  \         ['readonly', 'filename'],
  \     ],
  \ },
  \ 'tabline': {'left': [['buffers']], 'right': []},
  \ 'component_function': {'filename': 'LightlineFilename'},
  \ 'component_expand': {'buffers': 'lightline#bufferline#buffers'},
  \ 'component_type': {'buffers': 'tabsel'},
  \ 'separator': {'left': '', 'right': ''},
  \ 'subseparator': {'left': '', 'right': ''},
  \ }

function! LightlineFilename()
    let filename = expand('%:t')
    let filename = filename !=# '' ? filename : '*'
    let icon = &filetype !=# ''
      \ ? WebDevIconsGetFileTypeSymbol()
      \ : WebDevIconsGetFileTypeSymbol('')
    let modified = &modified ? ' +' : ''
    return icon . ' ' . filename . modified
endfunction

" lightline-bufferline
let g:lightline#bufferline#enable_devicons = 1

" vim-polyglot
let g:python_highlight_all = 1 " Enable all python syntax highlighting features
let g:polyglot_disabled = ['yaml']

" fzf.vim
nnoremap <silent> <c-p> :Files<cr>
nnoremap <silent> <leader>j :Buffers<cr>
nnoremap <silent> <leader>rg :Rg<cr>

" vim-easy-align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" vim-sneak
highlight link Sneak IncSearch

" camelcasemotion
let g:camelcasemotion_key = '<leader>'

" completor.vim
let g:completor_complete_options = 'menuone,noinsert'
let g:completor_min_chars = 1
set shortmess+=c
set belloff+=ctrlg


" =============================================================================
"                                    misc
" =============================================================================
" Jump to last position when opening a file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Trim trailing whitespace on write
au BufWritePre * %s/\s\+$//e

" Use 2 space tabs for yaml files
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
