" Read .projections.json for file type metadata.

if g:editor_only || !filereadable('.projections.json') && empty(g:projectionist_heuristics)
  finish
endif

packadd vim-projectionist

" autocmd User ProjectionistActivate call s:linters()
" function! s:linters() abort
"   for [dir, value] in projectionist#query('linters')
"     let b:ale_linters = {&filetype: value}
"     break
"   endif
" endfunction
