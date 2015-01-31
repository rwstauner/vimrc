"hi diffFile ctermfg=cyan
"hi diffAdded ctermfg=green
"hi diffRemoved ctermfg=red

hi def link diffOldFile         diffFile
hi def link diffNewFile         diffFile
hi     link diffFile            Identifier
hi def link diffOnly            Special
hi def link diffIdentical       Special
hi def link diffDiffer          Special
hi def link diffBDiffer         Special
hi def link diffIsA             Special
hi def link diffNoEOL           Special
hi def link diffCommon          Special
hi     link diffRemoved         Constant
hi     link diffChanged         PreProc
hi     link diffAdded           Type
hi def link diffLine            Statement
hi def link diffSubname         PreProc
hi def link diffComment         Comment
