" set the bg color to a dark grey so that TT2 syntax stands out

if !exists("s:tt2_custom")
  runtime macros/customize_highlight.vim
  let s:tt2_custom = CustomizeHighlight('tt2.\+', 'ctermbg=236')
else
  exe join(s:tt2_custom, "\n")
endif
