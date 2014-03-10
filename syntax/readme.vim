if exists("b:current_syntax")
  finish
endif
let b:current_syntax = "readme"

call SetFileTypeSH("bash")
syn include @readmeShell syntax/sh.vim

syn match   readmeChars     /\v[-=*]+/
syn match   readmeVars      /\v\<[^>]+\>/
syn match   readmeOptional  /\v\[[^]]+\]/ contains=readmeVars
syn match   readmeURL       "\v([^[:space:]]+\@)?(\<[^>]+\>|[a-z]+):/+[^[:space:]]+" contains=readmeVars
syn match   readmeComment   /\v#.*$/ contains=readmeURL
syn region  readmeShellLine start=/\v^\s*\$+/ end=/\v(\\\n.+)*$/ keepend contains=@readmeShell,readmeVars,readmeURL,readmeOptional,readmeComment

" Define the default highlighting.
hi def link readmeChars      Special
hi def link readmeVars       Identifier
hi def link readmeOptional   Special
hi def link readmeURL        Type
hi def link readmeComment    Comment
hi def link readmeShellLine  Statement
