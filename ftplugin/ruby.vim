" Syntastic will automatically do better than this if available
compiler ruby
" add -w
setlocal makeprg=ruby\ -c\ -w\ %\ $*
