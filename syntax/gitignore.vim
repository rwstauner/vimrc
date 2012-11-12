syn match gitignoreComment   /\v^#.*/
syn match gitignoreInclude   /\v^!.+/
syn match gitignoreExclude   /\v^[^#!].*/

hi def link gitignoreComment Comment
hi def link gitignoreInclude Type
hi def link gitignoreExclude Constant

let b:current_syntax = "gitignore"
