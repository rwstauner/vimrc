" from gohtmltmpl

if exists("b:current_syntax")
  finish
endif

if !exists("g:main_syntax")
  let g:main_syntax = 'markdown'
endif

runtime! syntax/gotexttmpl.vim
runtime! syntax/markdown.vim
unlet b:current_syntax

let b:current_syntax = "gomarkdown"

" vim: sw=2 ts=2 et
