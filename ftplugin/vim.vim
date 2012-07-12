" map K to :help
setlocal keywordprg=:help
" TODO: this probably needs more keys (anything but white-space?)
setlocal iskeyword+=-,<,>,:

" in vim it's much more clear to think of them in terms of ^x
setlocal display-=uhex

" execute command under cursor (single line only)
nmap <Leader>:      yyq:p
