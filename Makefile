PROG=karavomarangos

prefix = /usr/local
bindir = $(prefix)/bin
sharedir = $(prefix)/share
mandir = $(sharedir)/man
man1dir = $(mandir)/man1

all: build

build:
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
	( rm $(DESTDIR)$(bindir)$(PROG) ) 
