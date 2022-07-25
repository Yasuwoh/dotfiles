all: help
.PHONY: install dir link

BINDIR=${HOME}/.local/bin

dir:
	install -d -m 755 ${HOME}/.local/bin

link:
	ln -sf `pwd`/cat_timestamp            ${BINDIR}/cat_timestamp
	ln -sf `pwd`/fetch_earthquake_data.py ${BINDIR}/fetch_earthquake_data.py
	ln -sf `pwd`/get_tmux_free            ${BINDIR}/get_tmux_free
	ln -sf `pwd`/get_tmux_loadavg         ${BINDIR}/get_tmux_loadavg
	ln -sf `pwd`/runat.py                 ${BINDIR}/runat.py
	ln -sf `pwd`/worlddate                ${BINDIR}/worlddate

install: dir link

