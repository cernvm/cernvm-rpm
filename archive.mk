
include config.mk

all: archive/artifacts-$(VERSION).tar.gz

archive/artifacts-$(VERSION).tar.gz:
	cd artifacts && gtar -cvz --transform 's,^\.,artifacts-$(VERSION),' --show-transformed-names -f ../archive/artifacts-$(VERSION).tar.gz \
	  `find . -maxdepth 1 -type f -name '*$(VERSION)*' ! -name '*\.rpm'`

