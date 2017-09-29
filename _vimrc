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
if exists ("mouse")
	set mouse=a
endif
set ttymouse=xterm2
set textwidth=0
set statusline=%f%m%r%h%w\ %<<\%{getcwd()}>%=\ \[%l,%c%V\]\[%{&ff}]\[%{&fileencoding}]%y
nnoremap j gj
nnoremap k gk
nnoremap <C-L> :nohl<CR><C-L>
