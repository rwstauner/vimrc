SHELL = /bin/bash
VIMRC = vimrc

.PHONY: all dirs plugins

all: dirs plugins

dirs:
	mkdir -p ~/.config
	test -d ~/.vim   || ln -s run_control/vimrc ~/.vim
	test -f ~/.vimrc || ln -s .vim/vimrc ~/.vimrc
	test -f ~/.ideavimrc || ln -s .vim/idea.vim ~/.ideavimrc
	test -d ~/.config/nvim  || ln -s ~/.vim ~/.config/nvim
	mkdir -p ~/.cache/{n,}vim-{cache,tmp,undo}

MINPAC_URL=https://github.com/k-takata/minpac.git
MINPAC=pack/minpac/opt/minpac
$(MINPAC):
	git clone $(MINPAC_URL) $(MINPAC)
update-minpac:
	(cd $(MINPAC) && git pull)

plugins: $(MINPAC)
	vim -c 'source plugins.vim'
