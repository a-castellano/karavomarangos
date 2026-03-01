PROG=karavomarangos.sh

prefix = /usr/local
bindir = $(prefix)/bin
sharedir = $(prefix)/share
mandir = $(sharedir)/man
man1dir = $(mandir)/man1
etcdir = /etc
karavomarangos_etc = $(etcdir)/karavomarangos

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
	install -d $(DESTDIR)$(karavomarangos_etc)
	install -m 644 schema.json $(DESTDIR)$(karavomarangos_etc)/schema.json
	install -m 644 templates/Dockerfile.tmpl $(DESTDIR)$(karavomarangos_etc)/Dockerfile.tmpl
	install -m 644 templates/README.tmpl $(DESTDIR)$(karavomarangos_etc)/README.tmpl

uninstall:
	rm -f $(DESTDIR)$(bindir)/$(PROG)
	rm -f $(DESTDIR)$(karavomarangos_etc)/schema.json $(DESTDIR)$(karavomarangos_etc)/Dockerfile.tmpl $(DESTDIR)$(karavomarangos_etc)/README.tmpl
	-rmdir $(DESTDIR)$(karavomarangos_etc) 2>/dev/null || true
