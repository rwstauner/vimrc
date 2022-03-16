echom "updating plugins"

packadd minpac

command! -n=1 Add :call minpac#add(<q-args>)
command! -n=1 Opt :call minpac#add(<q-args>, {'type': 'opt'})

call minpac#init()

Opt k-takata/minpac


" enable repeating certain plugin actions with . (autoloaded)
Add tpope/vim-repeat

" navigate various things back and forth with [x and ]x (t,l,q...)
Opt tpope/vim-unimpaired

" better management of quotes and paired symbols than i used to do
Add tpope/vim-surround


call minpac#clean()
call minpac#update()

call minpac#status()
