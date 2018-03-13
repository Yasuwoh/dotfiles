" VIMオリジナルモード
set nocompatible
" 補完モードON
set wildmenu
" 入力中のコマンドを表示
set showcmd
" 検索文字列をハイライト
set hlsearch
" 行番号を表示
set number
" 現在行に下線を表示
set cursorline
" 長い行は折り返す
set wrap
" ルーラーを使う・・・が、statuslineを使っているので無意味
set ruler
" シンタックスハイライト
syntax on
" インデント周り
set autoindent
set smartindent
set expandtab
"set cindent
set tabstop=4
set softtabstop=4
set shiftwidth=4

" コマンド履歴
set history=200

" ディレクトリの設定
if has('win32') || has('win64')
    set backupdir=~/vimbackup
else
    set backupdir=~/.vimbackup
endif
" 終了してもundoの効力を失わない
if has('persistent_undo')
    set undofile
    if has('win32') || has('win64')
        set undodir=~/vimundo
    else
        set undodir=~/.vimundo
    endif
endif
" 終了時にカーソル位置を記憶しておく
augroup vimrcEx
    au BufRead * if line ("'\"") > 0 && line("'\"") <= line("$") |
    \ exe "normal g`\"" | endif
augroup END
" バッファを切り替えてもundoの効力を失わない
set hidden
" 括弧の入力時、対応する括弧を表示
set showmatch
" 検索関連
set ignorecase  " 大文字小文字を区別しない
set smartcase   " ただし、大文字が入力された場合は大文字小文字を区別する
set incsearch   " インクリメンタルサーチを行う
" バックスペースで自動インデントを消す
" バックスペースで行末を消して前の行へ戻る
" インサートモードを開始したキャレットよりも前の文字列を消せる
set backspace=indent,eol,start
" マウスを使う
if exists ("mouse")
	set mouse=a
	set ttymouse=xterm2
endif
" 長い行でも自動的に改行しない
set textwidth=0
" ステータスラインを常に表示
set laststatus=2
" ステータスラインの文字列
set statusline=%f%m%r%h%w%q\ %<<%{getcwd()}>%=\ [%l,%c%V,%P][%{&ff}][%{&fileencoding}]%y
" %f: ファイル名(相対パス)
" %m: 編集フラグ [+]
" %r: 読み取り専用フラグ [RO]
" %h: ヘルプフラグ [help]
" %w: プレビューフラグ [Preview]
" %q: クイックフィックスリストフラグ [Quickfix List] or ロケーションリストフラグ [Location List]
" \ : スペースをエスケープ
" \%{getcwd()}: カレントディレクトリ
" %=: 区切り
" %l: 行番号
" %c: 列番号
" %V: 仮想列番号。実列番号(%c)と同一の場合は、空文字列
" %{&ff}: ファイルフォーマット(改行コード)
" %{&fileencoding}: ファイルエンコーディング(文字コード)
" %y: ファイルタイプ(シンタックス)
"
" 論理行よりむしろ、見えている行でカーソル移動
nnoremap j gj
nnoremap k gk
" C-L で検索ハイライトも消す
nnoremap <C-L> :nohl<CR><C-L>


" GUIで動作していない場合、タイトルを自動設定
if !has('gui_running')
    set title
    " ターミナルがscreenの場合のエスケープ文字列
    if &term =~ '^screen'
        set t_ts=k
        set t_fs=\
    endif
    " タイトル文字列
    set titlestring=%{GetTitleString()}
endif

" タイトル文字列
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

