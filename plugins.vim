echom "updating plugins"

packadd minpac

call minpac#init()

call minpac#add('k-takata/minpac', {'type': 'opt'})

" enable repeating certain plugin actions with .
call minpac#add('tpope/vim-repeat')

" navigate various things back and forth with [x and ]x (t,l,q...)
call minpac#add('tpope/vim-unimpaired', {'type': 'opt'})

" better management of quotes and paired symbols than i used to do
call minpac#add('tpope/vim-surround')

call minpac#clean()
call minpac#update()

call minpac#status()
