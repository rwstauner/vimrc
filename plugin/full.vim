" Setup any plugins for when using FRD [n]vim (not embedded editor).
if g:editor_only
  finish
endif

packadd vim-write-plus

" Open "file:line" as file at line.
packadd vim-fetch
