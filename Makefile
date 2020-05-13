all: help
.PHONY: all gather deploy dir gitrepos diff clean help

DIFF=-u

gather:
	install -m 644 ${HOME}/.zshrc           _zshrc
	install -m 644 ${HOME}/.zprofile        _zprofile
	install -m 644 ${HOME}/.screenrc        _screenrc
	install -m 644 ${HOME}/.screen/layout   _screen_layout
	install -m 644 ${HOME}/.vimrc           _vimrc
	install -m 644 ${HOME}/.pythonrc        _pythonrc 
	install -m 644 ${HOME}/.gitconfig       _gitconfig
	install -m 644 ${HOME}/.tmux.conf       _tmux.conf

deploy: dir
	install -m 644 _zshrc           ${HOME}/.zshrc
	install -m 644 _zprofile        ${HOME}/.zprofile
	install -m 644 _screenrc        ${HOME}/.screenrc
	install -m 644 _screen_layout   ${HOME}/.screen/layout
	install -m 644 _vimrc           ${HOME}/.vimrc
	install -m 644 _pythonrc        ${HOME}/.pythonrc
	install -m 644 _gitconfig       ${HOME}/.gitconfig
	install -m 644 _tmux.conf       ${HOME}/.tmux.conf
	install -m 755 bin/get_tmux_loadavg	${HOME}/bin/get_tmux_loadavg
	install -m 755 bin/get_tmux_free	${HOME}/bin/get_tmux_free
	install -m 755 bin/cat_timestamp	${HOME}/bin/cat_timestamp
	install -m 755 bin/fetch_earthquake_data.py ${HOME}/bin/fetch_earthquake_data.py
	install -m 755 bin/worlddate	${HOME}/bin/worlddate
	make -C fortunes install

dir:
	install -d -m 755 ${HOME}/bin
	install -d -m 755 ${HOME}/gitrepos
	install -d -m 755 ${HOME}/.vim/pack
	install -d -m 755 ${HOME}/.vimbackup
	install -d -m 755 ${HOME}/.vimundo
	install -d -m 755 ${HOME}/.screen
	install -d -m 755 ${HOME}/.screen/hardcopy
	install -d -m 755 ${HOME}/.screen/log
	install -d -m 755 ${HOME}/.tmux
	install -d -m 755 ${HOME}/.tmux/log
	install -d -m 755 ${HOME}/.tmux/hardcopy
	install -d -m 755 ${HOME}/.zsh/plugins

gitrepos: dir
	-git clone https://github.com/vim/vim.git \
		${HOME}/gitrepos/vim
	-git clone https://github.com/vim-jp/vimdoc-ja.git \
		${HOME}/gitrepos/vimdoc-ja
	-git clone https://github.com/tmux/tmux.git \
		${HOME}/gitrepos/tmux
	-git clone https://github.com/zsh-users/zsh-completions \
		${HOME}/gitrepos/zsh-completions
	-git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		${HOME}/gitrepos/zsh-syntax-highlighting
	-git clone https://github.com/zsh-users/zaw.git \
		${HOME}/gitrepos/zaw
	#
	install -d -m 755 ${HOME}/.vim/pack/vimdoc-ja/start
	-ln -s ${HOME}/gitrepos/vimdoc-ja \
		${HOME}/.vim/pack/vimdoc-ja/start/vimdoc-ja
	-ln -s ${HOME}/gitrepos/zsh-completions \
		${HOME}/.zsh/plugins/zsh-completions
	-ln -s ${HOME}/gitrepos/zsh-syntax-highlighting \
		${HOME}/.zsh/plugins/zsh-syntax-highlighting
	-ln -s ${HOME}/gitrepos/zaw \
		${HOME}/.zsh/plugins/zaw

diff:
	-diff $(DIFF) ${HOME}/.zshrc            _zshrc
	-diff $(DIFF) ${HOME}/.zprofile         _zprofile
	-diff $(DIFF) ${HOME}/.screenrc         _screenrc
	-diff $(DIFF) ${HOME}/.screen/layout    _screen_layout
	-diff $(DIFF) ${HOME}/.vimrc            _vimrc
	-diff $(DIFF) ${HOME}/.pythonrc         _pythonrc
	-diff $(DIFF) ${HOME}/.gitconfig        _gitconfig
	-diff $(DIFF) ${HOME}/.tmux.conf        _tmux.conf

clean:
	make -C fortunes clean

help:
	@echo "make <deploy|gather|dir|diff|clean|help>"

