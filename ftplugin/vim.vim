" map K to :help
setlocal keywordprg=:help
" TODO: this probably needs more keys (anything but white-space?)
setlocal iskeyword+=-,<,>,:

" execute command under cursor (single line only)
nmap <Leader>:      yyq:p
