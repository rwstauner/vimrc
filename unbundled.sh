#!/bin/bash

cd "`dirname $0`"

function dl () {
  dest="unbundled/$1.vim" url="$2"
  if ! [[ -s "$dest" ]]; then
    mkdir -p "${dest%/*}"
    wget "$url" -O "$dest"
  fi
}

dl   syntax/bip    'https://projects.duckcorp.org/projects/bip/repository/revisions/master/raw/samples/bip.vim'

#dl ftplugin/groovy 'http://www.vim.org/scripts/download_script.php?src_id=8600'

dl   syntax/tmux   'http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/examples/tmux.vim?format=raw'

# for dir in syntax ftplugin; do
#   dl $dir/vimperator "http://vimperator-labs.googlecode.com/hg/vimperator/contrib/vim/$dir/vimperator.vim"
# done
