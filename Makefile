all: help
.PHONY: all gather deploy dir fortunes diff clean help

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

dir:
	install -d -m 755 ${HOME}/bin
	install -d -m 755 ${HOME}/.vimbackup
	install -d -m 755 ${HOME}/.vimundo
	install -d -m 755 ${HOME}/.screen
	install -d -m 755 ${HOME}/.screen/hardcopy
	install -d -m 755 ${HOME}/.screen/log
	install -d -m 755 ${HOME}/.tmux
	install -d -m 755 ${HOME}/.tmux/log
	install -d -m 755 ${HOME}/.tmux/hardcopy

fortunes: 
	make -C $@

diff:
	-diff ${HOME}/.zshrc            _zshrc
	-diff ${HOME}/.zprofile         _zprofile
	-diff ${HOME}/.screenrc         _screenrc
	-diff ${HOME}/.screen/layout    _screen_layout
	-diff ${HOME}/.vimrc            _vimrc
	-diff ${HOME}/.pythonrc         _pythonrc
	-diff ${HOME}/.gitconfig        _gitconfig
	-diff ${HOME}/.tmux.conf        _tmux.conf

clean:
	make -C fortunes clean

help:
	@echo "make <deploy|gather|dir|diff|clean|help>"

