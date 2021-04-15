if exists("b:current_syntax")
  finish
endif

runtime! syntax/clojure.vim
unlet b:current_syntax

let b:current_syntax = "joker"
