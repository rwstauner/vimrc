" set the bg color to a dark grey so that the template syntax stands out
if !exists("s:mako_custom")
  " also bgcolor the python tags or the mako lines will go back and forth
  let s:mako_custom = wounded#highlight#customize('\(mako\|python\).\+', 'ctermbg=236')
else
  exe join(s:mako_custom, "\n")
endif
