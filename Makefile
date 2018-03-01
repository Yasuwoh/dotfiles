all:

gather:
	cp -f ${HOME}/.zshrc    _zshrc
	cp -f ${HOME}/.zprofile _zprofile
	cp -f ${HOME}/.screenrc _screenrc
	cp -f ${HOME}/.vimrc    _vimrc

deploy: dir
	cp -f _zshrc    ${HOME}/.zshrc
	cp -f _zprofile ${HOME}/.zprofile
	cp -f _screenrc ${HOME}/.screenrc
	cp -f _vimrc    ${HOME}/.vimrc

dir:
	install -d -m 755 ${HOME}/.vimbackup
	install -d -m 755 ${HOME}/.vimundo
	install -d -m 755 ${HOME}/.screen
	install -d -m 755 ${HOME}/.screen/hardcopy
	install -d -m 755 ${HOME}/.screen/log
