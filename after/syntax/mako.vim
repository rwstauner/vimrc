if !exists("b:mako_custom_syntax")
  " add a few blocks to the definitions (the old vim file is a bit lacking)
  syn region makoTag matchgroup=makoDelim start="<%\(def\|call\|block\|namespace\|page\|include\|inherit\|[a-zA-Z_][a-zA-Z0-9_]*:[a-zA-Z_][a-zA-Z0-9_]*\)\>" end="/\?>"
  syn match makoDelim "</%\(def\|call\|block\|[a-zA-Z_][a-zA-Z0-9_]*:[a-zA-Z_][a-zA-Z0-9_]*\)>"

  " tell html what syntax groups should take precedence (see :help html.vim)
  syn cluster htmlPreproc add=makoLine,makoVariable,makoTag,makoDocComment,makoDefEnd,makoText,makoDelim,makoEnd,makoComment,makoEscape
endif


" set the bg color to a dark grey so that the template syntax stands out
if !exists("s:mako_custom")
  " also bgcolor the python tags or the mako lines will go back and forth
  let s:mako_custom = wounded#highlight#customize('\(mako\|python\).\+', 'ctermbg=236')
else
  exe join(s:mako_custom, "\n")
endif


" mako sets this to eruby... why?
let b:current_syntax = "html"
