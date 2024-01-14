if g:editor_only
  finish
endif

" Neovim has built-in support.
if !has('nvim')
  packadd editorconfig-vim
endif
