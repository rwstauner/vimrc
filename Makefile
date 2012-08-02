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
bundles: vundle
	perl -lne 'print qq[:Bundle $$1] if /^\s*(?:Bundle|(?:LazyCommand|FTBundle)\s+\S+)\s+(\S+)/; END { print for qw( :BundleInstall :qall) }' $(VIMRC) > $(INSTALL_SCRIPT)
	vim -s $(INSTALL_SCRIPT)

