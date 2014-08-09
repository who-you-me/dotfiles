" Neobundle
if has('vim_starting')
    set nocompatible
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundle 'tomasr/molokai'
NeoBundle 'davidhalter/jedi-vim'
NeoBundle 'jmcantrell/vim-virtualenv'
NeoBundle 'kchmck/vim-coffee-script'

call neobundle#end()

filetype plugin indent on

NeoBundleCheck

" Basic
set nobackup
set noswapfile
set backspace=indent,eol,start

" Indent
set autoindent
set smartindent
set expandtab
set tabstop=4 shiftwidth=4 softtabstop=0
"set paste

if has('autocmd')
    filetype indent on
    autocmd FileType html setlocal ts=2 sw=2
endif

" Apperance
set showmatch
set number
set list
set listchars=trail:-,eol:¬
set cursorline
syntax enable
set t_Co=256
colorscheme molokai

" Completion
set wildmenu

" Search
set wrapscan
set ignorecase
set smartcase
set hlsearch
nmap <ESC><ESC> ;nohlsearch<CR><ESC>

" Moving
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

