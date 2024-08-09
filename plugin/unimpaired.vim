if exists("g:vscode")
  nmap [a :call VSCodeNotify("workbench.action.previousEditor")<CR>
  nmap ]a :call VSCodeNotify("workbench.action.nextEditor")<CR>
endif

if g:editor_only
  finish
endif

" Back and forth in the jump list.
nnoremap [j <C-o>
nnoremap ]j <C-i>

packadd vim-unimpaired

" With <Leader> open a split for the next tag.
nmap <Leader>[t :sp +tN<CR>
nmap <Leader>]t :sp +tn<CR>
