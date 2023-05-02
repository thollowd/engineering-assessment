all:
	${MAKE} cpan
	${MAKE} test

cpan:
	sh install_cpan.sh

test:
	/usr/bin/prove -w t/
