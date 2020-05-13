scriptencoding utf-8


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
" 現在行をハイライト
set cursorline
highlight CursorLine cterm=None ctermbg=234
highlight CursorLineNr cterm=None ctermbg=234
" 現在列をハイライト
set cursorcolumn
highlight CursorColumn cterm=None ctermbg=234
" 長い行は折り返す
set wrap
" ルーラーを使う・・・が、statuslineを使っているので無意味
set ruler
" シンタックスハイライト
if has('gui') && (has('win32') || has('win64'))
    " syntax on "  こうすると、Kaoriya-VimでIME ONのときにカーソルが紫にならない。
else
    syntax on
endif
" インデント周り
set autoindent
set smartindent
set expandtab
"set cindent
" タブ(文字コード9)を何文字分のスペースで表示するか
set tabstop=4
" タブキーを押した時に何文字分のスペースが挿入されるか。0でtabstopと同値
set softtabstop=0
" 自動インデントで何文字分のスペースが挿入されるか。0でtabstopと同値
set shiftwidth=0

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
if has ("mouse")
    " どのモードでもマウスを使う
	set mouse=a
    " xterm のマウスエミュレート。しかも、ドラッグ中の内容も可視化する。
	set ttymouse=xterm2
endif
" 長い行でも自動的に改行しない
set textwidth=0
" ステータスラインを常に表示
set laststatus=2
" ステータスラインの文字列
set statusline=%n:%f%m%r%h%w%q\ %=%<%{getcwd()}\ [%l,%c%V,%P,%o][%B][%{&ff}][%{&fileencoding}]%y
" %n: バッファ番号
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
" %P: 表示パーセンテージ
" %{&ff}: ファイルフォーマット(改行コード)
" %{&fileencoding}: ファイルエンコーディング(文字コード)
" %y: ファイルタイプ(シンタックス)
"
" アクティブなペインのステータスバーのハイライト
" カラー端末ではシアン、GUIでは青にする
highlight StatusLine ctermfg=cyan guifg=darkblue
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

" clipboardが有効ならば、yankをクリップボードと連携
if has('clipboard')
    set clipboard=unnamed,autoselect
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


" 文字コードの自動認識
if &encoding !=# 'utf-8'
 set encoding=japan
 set fileencoding=japan
endif
if has('iconv')
 let s:enc_euc = 'euc-jp'
 let s:enc_jis = 'iso-2022-jp'
 " iconvがeucJP-msに対応しているかをチェック
 if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
   let s:enc_euc = 'eucjp-ms'
   let s:enc_jis = 'iso-2022-jp-3'
 " iconvがJISX0213に対応しているかをチェック
 elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
   let s:enc_euc = 'euc-jisx0213'
   let s:enc_jis = 'iso-2022-jp-3'
 endif
 " fileencodingsを構築
 if &encoding ==# 'utf-8'
   let s:fileencodings_default = &fileencodings
   let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
   let &fileencodings = &fileencodings .','. s:fileencodings_default
   unlet s:fileencodings_default
 else
   let &fileencodings = &fileencodings .','. s:enc_jis
   set fileencodings+=utf-8,ucs-2le,ucs-2
   if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
     set fileencodings+=cp932
     set fileencodings-=euc-jp
     set fileencodings-=euc-jisx0213
     set fileencodings-=eucjp-ms
     let &encoding = s:enc_euc
     let &fileencoding = s:enc_euc
   else
     let &fileencodings = &fileencodings .','. s:enc_euc
   endif
 endif
 " 定数を処分
 unlet s:enc_euc
 unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
 function! AU_ReCheck_FENC()
   if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
     let &fileencoding=&encoding
   endif
 endfunction
 autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
 set ambiwidth=double
endif



" REQUIRED. This makes vim invoke Latex-Suite when you open a tex file.
filetype plugin on

" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: This enables automatic indentation as you type.
filetype indent on

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='platex'

" ファイルタイプ個別の設定
autocmd FileType yaml   setlocal tabstop=2
