" Use spaces instead of tabs
set expandtab
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines
set smartcase

set ignorecase " Ignore case in search

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Turn syntax highlighting on.
syntax on

" show number + relative nubmer
set number relativenumber

" always show what mode
set showmode  

" highligt search
set hlsearch
" show search as type
set incsearch

set scrolloff=8 " always keep 8 lines above and below curson when scroll

set backspace=indent,eol,start  " more powerful backspacing
