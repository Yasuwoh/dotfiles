all: Civilization4.dat Civilization5.dat Law.dat

.PHONY: all install dir clean

Civilization4.dat: Civilization4
	strfile $< $@

Civilization5.dat: Civilization5
	strfile $< $@

Law.dat: Law
	strfile $< $@

install: dir all
	install -m 644 Civilization4     ${HOME}/fortunes
	install -m 644 Civilization4.dat ${HOME}/fortunes
	install -m 644 Civilization5     ${HOME}/fortunes
	install -m 644 Civilization5.dat ${HOME}/fortunes
	install -m 644 Law ${HOME}/fortunes
	install -m 644 Law.dat ${HOME}/fortunes

dir:
	install -d -m 755 ${HOME}/fortunes

clean:
	rm -f *.dat
