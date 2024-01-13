let g:editor_only = exists("g:vscode")

if exists("g:vscode")
  source ~/.vim/vscode.vim
else
  source ~/.vimrc
endif
