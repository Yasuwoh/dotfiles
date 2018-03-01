all:

gather:
	cp -f ${HOME}/.zshrc    _zshrc
	cp -f ${HOME}/.zprofile _zprofile
	cp -f ${HOME}/.screenrc _screenrc
	cp -f ${HOME}/.vimrc    _vimrc

deploy:
	cp -f _zshrc    ${HOME}/.zshrc
	cp -f _zprofile ${HOME}/.zprofile
	cp -f _screenrc ${HOME}/.screenrc
	cp -f _vimrc    ${HOME}/.vimrc

