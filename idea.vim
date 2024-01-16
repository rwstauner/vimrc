" IntelliJ IDEA IdeaVim
" See :actionlist for list of <Action>s that can be mapped.

if has('ide')
  let g:idea = 1
endif

let g:editor_only = exists("g:idea")

" There is no runtimepath so we source these directly.
fun! HomePlug(name)
  exe "source ~/.vim/plugin/" . a:name . ".vim"
endfun

command! -nargs=1 HomePlug :call HomePlug(<q-args>)

" There are no supported functions (like glob() or expand()) to get this list dynamically.

HomePlug comments
HomePlug navigate
HomePlug surround

" Running :NERDTree will activate additional key navigation in the file explorer bar.
set NERDTree
