set nocompatible
set wildmenu
set showcmd
set hlsearch
set number
syntax on
set autoindent
set smartindent
set history=50
set backupdir=~/.vimbackup
set undodir=~/.vimundo
set expandtab
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
	set ttymouse=xterm2
endif
set textwidth=0
set statusline=%f%m%r%h%w\ %<<\%{getcwd()}>%=\ \[%l,%c%V\]\[%{&ff}]\[%{&fileencoding}]%y
nnoremap j gj
nnoremap k gk
nnoremap <C-L> :nohl<CR><C-L>


set title
if &term =~ '^screen'
    set t_ts=k
    set t_fs=\
endif

set titlestring=%{GetTitleString()}

function! GetTitleString()
    " 各種フラグ
    let modified = getbufvar ('', '&mod') ? '+' : ''
    let readonly = getbufvar ('', '&ro') ? '=' : ''
    let modifiable = getbufvar ('', '&ma') ? '' : '-'
    let flag = modified . readonly . modifiable
    let flag = len(flag) ? '[' . flag . ']' : ''
    " ホスト名
    let host = hostname() . ':'
    " ファイル名
    let filename = expand ('%:t')
    " ファイル名がない場合
    let filename = len(filename) ? filename : '<NEW>'
    " パス内を置換する
    let dir = expand ('%:p:s!some-paths!PATH!:~:.:h')
    " dir を括弧で括る
    let dir = len(dir) && dir != '.' ? ' (' . dir . ')' : ''
    " 検索文字文字列
    let search_string = len(@/) ? ' [' . @/ . ']' : ''

    " 表示文字列を作成
    let str = 'vim@' . filename . flag

    " Screen などの時、タイトルバーに2バイト文字列があったら化けるので対処する
    if !has ('gui_running')
        let str2 = ''
        for char in split (str, '\zs')
            let str2 = str2 . (char2nr (char) > 255 ? '_' : char)
        endfor
        let str = str2
    endif
    return str
endfunction



