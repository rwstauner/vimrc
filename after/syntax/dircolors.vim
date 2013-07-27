let &t_Co = b:dircolors_t_co
unlet       b:dircolors_t_co

" The 16-color version uses CamelCase words which vim doesn't seem to like.

  hi def      dircolorsBlack      ctermfg=black guifg=black
  hi def      dircolorsRed        ctermfg=red guifg=red
  hi def      dircolorsGreen      ctermfg=green guifg=green
  hi def      dircolorsYellow     ctermfg=yellow guifg=yellow
  hi def      dircolorsBlue       ctermfg=blue guifg=blue
  hi def      dircolorsMagenta    ctermfg=magenta guifg=magenta
  hi def      dircolorsCyan       ctermfg=cyan guifg=cyan
  hi def      dircolorsWhite      ctermfg=white guifg=white
  hi def      dircolorsBGBlack    ctermbg=black ctermfg=white
                                  \ guibg=black guifg=white
  hi def      dircolorsBGRed      ctermbg=darkred guibg=darkred
  hi def      dircolorsBGGreen    ctermbg=darkgreen guibg=darkgreen
  hi def      dircolorsBGYellow   ctermbg=darkyellow guibg=darkyellow
  hi def      dircolorsBGBlue     ctermbg=darkblue guibg=darkblue
  hi def      dircolorsBGMagenta  ctermbg=darkmagenta guibg=darkmagenta
  hi def      dircolorsBGCyan     ctermbg=darkcyan guibg=darkcyan
  hi def      dircolorsBGWhite    ctermbg=white ctermfg=black
                                  \ guibg=white guifg=black
