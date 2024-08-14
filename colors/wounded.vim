" personal vim colorscheme

set background=dark
hi clear | " Remove all existing highlighting and set the defaults.

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
    syntax reset
endif

"colorscheme default
let g:colors_name = "wounded" | " just let colors_name ?

" See ./guicolors.pl for color hex codes.

" To see examples:
" :so $VIMRUNTIME/syntax/hitest.vim


" syntax highlight groups
hi Comment      guifg=#9595fb ctermfg=blue
hi Constant     guifg=#ff5555 ctermfg=red
hi Identifier   guifg=#55ffff ctermfg=cyan   gui=NONE cterm=NONE
hi Statement    guifg=#ffff4f ctermfg=yellow gui=NONE cterm=NONE
hi PreProc      guifg=#dd5fdd ctermfg=darkmagenta
hi Type         guifg=#55ff55 ctermfg=green
hi Special      guifg=#ff55ff ctermfg=magenta
hi SpecialChar  guifg=#ff55ff ctermfg=magenta
hi Underlined   gui=underline cterm=underline
hi Ignore       guifg=grey ctermfg=grey
hi Error        guifg=white ctermfg=white  guibg=#ff5555 ctermbg=red  gui=bold cterm=bold
hi Todo         gui=bold cterm=bold  guifg=white ctermfg=white  guibg=#9595fb ctermbg=blue

" regular highlight groups

" 'colorcolumn'
" set cterm=none to undo cterm=reverse
hi ColorColumn  guibg=#262626 ctermbg=235 cterm=none

"hi Cursor      the character under the cursor
"hi CursorIM

"hi Directory   directory names (and other special names in listings)

hi DiffAdd      guibg=#005f00 ctermbg=22
hi DiffChange   guibg=#00005f ctermbg=17
hi DiffDelete   guibg=#5f0000 ctermbg=52
hi DiffText     guibg=#87005f ctermbg=89

hi ErrorMsg     gui=bold cterm=bold  guifg=white ctermfg=white  guibg=#ff5555 ctermbg=red
"hi VertSplit   the column separating vertically split windows
hi Folded       guifg=black ctermfg=black  guibg=#64caca ctermbg=darkcyan

hi FoldColumn   guifg=#55ffff ctermfg=cyan  guibg=#3a3a3a ctermbg=237
hi SignColumn   guibg=#585858 ctermbg=240

"hi IncSearch   'incsearch' highlighting; also used for the text replaced with
hi LineNr       gui=bold cterm=bold  guifg=#dbcb1d ctermfg=darkyellow  guibg=NONE ctermbg=NONE
hi MatchParen   gui=bold cterm=bold  guifg=black ctermfg=black  guibg=#6d6dd9 ctermbg=darkblue
"hi ModeMsg     'showmode' message (e.g., "-- INSERT --")
"hi MoreMsg     |more-prompt|
hi NonText      guifg=darkgrey ctermfg=darkgrey  guibg=NONE ctermbg=NONE  gui=bold cterm=bold
"hi Normal

hi Pmenu        guifg=black ctermfg=black  guibg=#55ff55 ctermbg=green    gui=bold cterm=bold
hi PmenuSel     guifg=black ctermfg=black  guibg=#ff55ff ctermbg=magenta  gui=bold cterm=bold
"hi PmenuSbar
"hi PmenuThumb
"hi Question    |hit-enter| prompt and yes/no questions

"hi Search      guifg=white ctermfg=white guibg=#ff55ff ctermbg=magenta gui=underline,bold cterm=underline,bold
hi Search       gui=NONE cterm=NONE  guifg=black ctermfg=black  guibg=#ffff55 ctermbg=yellow
hi SpecialKey   guifg=#585858 ctermfg=240  guibg=NONE ctermbg=NONE  gui=bold cterm=bold

hi SpellBad     gui=bold cterm=bold  guifg=black ctermfg=black  guibg=#ff5555 ctermbg=red
hi SpellCap     gui=bold cterm=bold  guifg=black ctermfg=black  guibg=#ff55ff ctermbg=magenta
hi SpellRare    gui=bold cterm=bold  guifg=black ctermfg=black  guibg=#55ffff ctermbg=cyan
hi SpellLocal   gui=bold cterm=bold  guifg=black ctermfg=black  guibg=#55ff55 ctermbg=green

hi StatusLine   gui=bold cterm=bold  guibg=#303030 ctermbg=236  guifg=#55ff55 ctermfg=green
hi StatusLineNC gui=bold cterm=bold  guibg=#262626 ctermbg=235  guifg=#ff55ff ctermfg=magenta

"hi Title       titles for output from ":set all", ":autocmd" etc.
hi Visual       guifg=white ctermfg=white  guibg=#ff55ff ctermbg=magenta  gui=bold cterm=bold
"hi VisualNOS   Visual mode selection when vim is "Not Owning the Selection".  Only X11 Gui's |gui-x11| and |xterm-clipboard| supports this.
"hi WarningMsg  warning messages
"hi WildMenu    current match in 'wildmenu' completion

" statline plugin
hi link User1   Identifier
hi link User2   Statement
hi link User3   Error
hi link User4   Special

if has('nvim')
  hi link TermCursor Cursor
  hi! link String Constant
  hi TermCursorNC guibg=#ff5555 ctermbg=red  guifg=white ctermfg=white
endif
