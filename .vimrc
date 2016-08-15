" Neobundle
if has('vim_starting')
    set nocompatible
    set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'tomasr/molokai'
NeoBundle 'davidhalter/jedi-vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'derekwyatt/vim-scala'

call neobundle#end()

filetype plugin indent on

NeoBundleCheck

" Enable neocomplete
let g:neocomplete#enable_at_startup = 1

autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0

" Nerdtree
if !argc()
    autocmd vimenter * NERDTree
endif

" Basic
set nobackup
set noswapfile
set backspace=indent,eol,start

" Indent
set autoindent
set smartindent
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
"set paste

if has('autocmd')
    filetype indent on
    autocmd FileType python setlocal ts=4 sw=4 sts=4
endif

" Apperance
set showmatch
set number
set list
set listchars=tab:>-,trail:-,eol:¬
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
