" The syntax file in the homebrewed vim overwrites this, so overwrite that.
SourceCodeStyle

" one sw is sufficient (i don't need two)
let g:pyindent_open_paren = &sw

compiler nose
" only test current file
let &l:makeprg = &l:makeprg . ' %'
