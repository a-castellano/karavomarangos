PROG=karavomarangos.sh

prefix = /usr/local
bindir = $(prefix)/bin
sharedir = $(prefix)/share
mandir = $(sharedir)/man
man1dir = $(mandir)/man1

all: build

# Regenerate argument parsing library from argbash template when .m4 is newer
lib/05-argbash.sh: lib/05-argbash.m4
	argbash $< -o $@ --strip user-content

build: lib/05-argbash.sh
	( cp -R lib clean_lib )
	( find clean_lib -type f -exec sed  -i '/^\#.*$$/d' {} \; )
	( find clean_lib -type f -exec sed  -i '/source .*$$/d' {} \; )
	( perl -pe 's/source lib\/(.*)$$/`cat clean_lib\/$$1`/e'  src/karavomarangos.sh > $(PROG) )
	( chmod 755 $(PROG) )
	( rm -rf clean_lib )

clean:
	( rm -f $(PROG) )

install:
	install $(PROG) $(DESTDIR)$(bindir)

uninstall:
	rm -f $(DESTDIR)$(bindir)/$(PROG) 
