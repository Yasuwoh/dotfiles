all: Civilization4.dat Civilization5.dat Law.dat Definition.dat

.PHONY: all install dir clean

FORTUNESDIR = ${HOME}/.local/share/games/fortunes

Civilization4.dat: Civilization4
	strfile $< $@

Civilization5.dat: Civilization5
	strfile $< $@

Law.dat: Law
	strfile $< $@

Definition.dat: Definition
	strfile $< $@

install: dir all
	install -m 644 Civilization4     ${FORTUNESDIR}/
	install -m 644 Civilization4.dat ${FORTUNESDIR}/
	install -m 644 Civilization5     ${FORTUNESDIR}/
	install -m 644 Civilization5.dat ${FORTUNESDIR}/
	install -m 644 Law               ${FORTUNESDIR}/
	install -m 644 Law.dat           ${FORTUNESDIR}/
	install -m 644 Definition        ${FORTUNESDIR}/
	install -m 644 Definition.dat    ${FORTUNESDIR}/

dir:
	install -d -m 755 ${FORTUNESDIR}

clean:
	rm -f *.dat
