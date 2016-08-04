set nocompatible
set wildmenu
set showcmd
set hlsearch
set number
syntax on
set autoindent
set smartindent
set history=50
set backupdir=~/vimbackup
set undodir=~/vimundo
set tabstop=4
set softtabstop=4
set shiftwidth=4
set hidden
set showmatch
set ignorecase
set smartcase
set backspace=indent,eol,start
set incsearch
set wrap
set ruler
set laststatus=2
set mouse=a
set textwidth=0
set statusline=%f%m%r%h%w\ %<<\%{getcwd()}>%=\ \[%lçs,%c%V\óÒ]\[%{&ff}]\[%{&fileencoding}]%y
nnoremap j gj
nnoremap k gk
nnoremap <C-L> :nohl<CR><C-L>
