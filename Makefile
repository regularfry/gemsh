NAME=gemsh
VERSION=0.0.1
AUTHOR=regularfry
URL=https://github.com/$(AUTHOR)/$(NAME)

DIRS=etc lib bin sbin share
INSTALL_DIRS=`find $(DIRS) -type d 2>/dev/null`
INSTALL_FILES=`find $(DIRS) -type f 2>/dev/null`
DOC_FILES=*.md *.txt

PKG_DIR=pkg
PKG_NAME=$(NAME)-$(VERSION)
PKG=$(PKG_DIR)/$(PKG_NAME).tar.gz
SIG=$(PKG_DIR)/$(PKG_NAME).asc

DESTDIR?=/
PREFIX?=/usr/local
INSTALL_PATH=$(DESTDIR)/$(PREFIX)
DOC_DIR=$(INSTALL_PATH)/share/doc/$(PKG_NAME)

pkg:
	mkdir $(PKG_DIR)

share/man/man1/gemsh.1: doc/man/gemsh.1.md
	kramdown-man doc/man/gemsh.1.md > share/man/man1/gemsh.1

man: share/man/man1/gemsh.1 
	git commit -m "Updated the man pages" \
		doc/man/gemsh.1.md share/man/man1/gemsh.1 

download: pkg
	wget -O $(PKG) $(URL)/archive/v$(VERSION).tar.gz

build: pkg
	git archive --output=$(PKG) --prefix=$(PKG_NAME)/ HEAD

sign: $(PKG)
	gpg --sign --detach-sign --armor $(PKG)
	git add $(PKG).asc
	git commit $(PKG).asc -m "Added PGP signature for v$(VERSION)"
	git push

verify: $(PKG) $(SIG)
	gpg --verify $(SIG) $(PKG)

clean:
	rm -f $(PKG) $(SIG)

all: $(PKG) $(SIG)

tag:
	git push
	git tag -s -m "Tagging $(VERSION)" v$(VERSION)
	git push --tags

release: tag download sign

install:
	for dir in $(INSTALL_DIRS); do mkdir -p $(INSTALL_PATH)/$$dir; done
	for file in $(INSTALL_FILES); do cp $$file $(INSTALL_PATH)/$$file; done

install_docs:
	mkdir -p $(DOC_DIR)
	cp -r $(DOC_FILES) $(DOC_DIR)/

uninstall:
	for file in $(INSTALL_FILES); do rm -f $(INSTALL_PATH)/$$file; done
	rm -rf $(DOC_DIR)

.PHONY: build man download sign verify clean test tag release install \
	uninstall all install_docs
