SHELL = /bin/bash
VIMRC = vimrc

.PHONY: all plug

all: dirs plug

dirs:
	test -d ~/.config/nvim  || ln -s ~/.vim ~/.config/nvim
	test -d ~/.vim   || ln -s run_control/vimrc ~/.vim
	test -f ~/.vimrc || ln -s .vim/vimrc ~/.vimrc
	mkdir -p ~/.cache/vim-{cache,tmp,undo}

PLUG_DIR=plugged/vim-plug
PLUG=autoload/plug.vim
plug: $(PLUG)
	vim +PlugInstall +qall
$(PLUG_DIR):
	mkdir -p $(dir $(PLUG))
	git clone https://github.com/junegunn/vim-plug $(PLUG_DIR)
$(PLUG): $(PLUG_DIR)
	# Use cp instead of ln (hard or soft) so make will acknowledge its existence.
	/bin/cp -vf $(PLUG_DIR)/plug.vim $(PLUG)
plug-up: $(PLUG_DIR)
	(cd $(PLUG_DIR) && git pull)
	$(MAKE) plug
