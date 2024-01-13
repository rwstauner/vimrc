if exists("g:vscode")
  xmap gc  <Plug>VSCodeCommentary
  nmap gc  <Plug>VSCodeCommentary
  omap gc  <Plug>VSCodeCommentary
  nmap gcc <Plug>VSCodeCommentaryLine

  finish
elseif exists("g:idea")
  set commentary

  finish
endif

packadd vim-commentary
