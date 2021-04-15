let s:bcs = b:current_syntax
unlet b:current_syntax

syn include @shellSQL syntax/sql.vim

let b:current_syntax = s:bcs

syn region shellHereDocSQL start=/<<SQL\>/ end=/^SQL$/ keepend contains=@shellSQL
