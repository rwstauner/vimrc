if g:editor_only
  finish
endif

" fast terminal connection, smoother redrawing
set ttyfast

" fix ctrl-arrow to work in command line mode (:help term.txt)
" vim doesn't have t_XX codes for C-arrow but S-arrow performs the same function
set t_#4=[1;5D
set t_%i=[1;5C
" make ctrl-pg up/down cycle tabs like they're supposed to
"set t_K3=[5;5~
"set t_K5=[6;5~
"nmap <kPageUp>   gT
"nmap <kPageDown> gt

" Arrow keys: UDRL => ABCD

" <C-Up> <C-Down> (like ctrl-e/y but with one hand)
if has('nvim')
  nnoremap <C-Up> <C-y>
  nnoremap <C-Down> <C-e>
else
  nnoremap [1;5A <C-y>
  nnoremap [1;5B <C-e>
endif

" compatibility with shell movement (and/or when i wrongfully hold shift)
" Ctrl-arrow (C-Left C-Right) moves across words.
nnoremap [1;5C w
nnoremap [1;5D b
" Ctrl-Shift-arrow (C-S-Left C-S-Right) moves across shell words (non-space).
nnoremap [1;6C W
nnoremap [1;6D B

" 256 color detection works
" (at least with gnome-terminal TERM=xterm-256color tmux TERM=screen-256color)
" Currently with xfce4-terminal and tmux everything ends up bold.
if &term =~ "-256color" && $XDG_CURRENT_DESKTOP == "XFCE" && $TMUX != ""
  "set t_Co=256
  set t_AB=[48;5;%dm
  set t_AF=[38;5;%dm
endif

" 16 colors
" if has("terminfo")
  " set t_Co=16
  " set t_AB=[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{92}%+%;%dm
  " set t_AF=[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{82}%+%;%dm
" else
  " set t_Co=16
  " set t_Sf=[3%dm
  " set t_Sb=[4%dm
" endif

"" 8 colors
" if &term =~ "xterm"
"  if has("terminfo")
"    set t_Co=8
"    set t_Sf=[3%p1%dm
"    set t_Sb=[4%p1%dm
"  else
"    set t_Co=8
"    set t_Sf=[3%dm
"    set t_Sb=[4%dm
"  endif
" endif
