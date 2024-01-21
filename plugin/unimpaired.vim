if g:editor_only
  finish
endif

packadd vim-unimpaired

" With <Leader> open a split for the next tag.
nmap <Leader>[t :sp +tN<CR>
nmap <Leader>]t :sp +tn<CR>
