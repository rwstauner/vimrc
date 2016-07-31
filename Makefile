SHELL = /bin/bash
VIMRC = vimrc

.PHONY: all vundle bundles

# by default just install the bundles that are always enabled
all: vundle

vundle: bundle/vundle
bundle/vundle:
	mkdir -p bundle
	git clone https://github.com/gmarik/vundle $@
	vim +BundleInstall +qall

# find all bundles (regular, filetype, lazy, etc) and install them
INSTALL_SCRIPT = .cache/install-bundles.vim
bundles: install-bundles

update-bundles install-bundles: vundle
	perl -lne 'print qq[:Bundle $$1] if /(?:^\s*(?:Bundle|LazyCommand|FTBundle)|LazyBundle)\s+.*?(([\047\042])\S+?\2)/;' \
		$(VIMRC) > $(INSTALL_SCRIPT)
	echo $$':BundleInstall$(if $(findstring update,$@),!)\n:wincmd p\n:wincmd c' >> $(INSTALL_SCRIPT)
	cat    $(INSTALL_SCRIPT)
	vim -s $(INSTALL_SCRIPT)
