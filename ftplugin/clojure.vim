function! ClojureNsToPath(ns)
  return substitute( substitute(a:ns, '-', '_', 'g'), '\.', '/', 'g')
endfunction
setl includeexpr=ClojureNsToPath(v:fname)
setl suffixesadd=.cljc,.clj,.cljs
setl path+=src

iabbr <buffer> timbre taoensso.timbre

setl formatprg=cljstyle\ pipe

autocmd User ProjectionistDetect
  \ if len(b:projectionist) == 0 |
  \   call projectionist#append(substitute(g:projectionist_file, "\\(^\\|/\\)\\(src\\|test\\)/.\\{-}\\.clj.\\?", "", ""), {
  \     "src/*.clj": {"alternate": "test/{}_test.clj"},
  \     "test/*_test.clj": {"alternate": "src/{}.clj"},
  \     "src/*.cljc": {"alternate": "test/{}_test.cljc"},
  \     "test/*_test.cljc": {"alternate": "src/{}.cljc"},
  \     "src/*.cljs": {"alternate": "test/{}_test.cljs"},
  \     "test/*_test.cljs": {"alternate": "src/{}.cljs"},
  \   }) |
  \ endif

" Use "format whole file" as a signal to enable it automatically on write.
" function! ClojuregqG()
"  let g:cljstyle_on_write = 1
"  norm! gqG
" endfunction
" nnoremap gqG :call ClojuregqG()<CR>

" FIXME: a bit jarring, need to configure cljstyle to do less first
function! CljStyleFile()
  if !exists("g:cljstyle_on_write")
    return
  endif
  norm! mcgg0gqGg`c
endfunction

augroup user-clojure
  autocmd!
  autocmd BufWritePre * call CljStyleFile()
augroup END
