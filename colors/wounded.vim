" personal vim colorscheme

set background=dark
hi clear | " Remove all existing highlighting and set the defaults.

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
    syntax reset
endif
"
"colorscheme default
let g:colors_name = "wounded" | " just let colors_name ?

" syntax highlight groups
hi Comment      ctermfg=blue
hi Constant     ctermfg=red
hi Identifier   ctermfg=cyan cterm=none
hi Statement    ctermfg=yellow
hi PreProc      ctermfg=darkmagenta
hi Type         ctermfg=green
hi Special      ctermfg=magenta
hi SpecialChar  ctermfg=magenta
hi Underlined   cterm=underline
hi Ignore       ctermfg=grey
hi Error        ctermfg=white ctermbg=red cterm=bold
hi Todo         ctermfg=white ctermbg=blue

" regular highlight groups
"hi Cursor      the character under the cursor
"hi CursorIM
"hi Directory   directory names (and other special names in listings)
"hi DiffAdd     diff mode: Added line |diff.txt|
"hi DiffChange  diff mode: Changed line |diff.txt|
"hi DiffDelete  diff mode: Deleted line |diff.txt|
"hi DiffText    diff mode: Changed text within a changed line |diff.txt|
hi ErrorMsg     cterm=bold ctermfg=white ctermbg=red
"hi VertSplit   the column separating vertically split windows
hi Folded       ctermfg=black ctermbg=darkcyan
hi FoldColumn   ctermfg=cyan ctermbg=darkgrey
"hi SignColumn  column where |signs| are displayed
"hi IncSearch   'incsearch' highlighting; also used for the text replaced with
hi LineNr       cterm=bold ctermfg=darkyellow ctermbg=none
hi MatchParen   cterm=bold ctermfg=black ctermbg=darkblue
"hi ModeMsg     'showmode' message (e.g., "-- INSERT --")
"hi MoreMsg     |more-prompt|
hi NonText      ctermfg=darkgrey ctermbg=none cterm=bold
"hi Normal
"hi Question    |hit-enter| prompt and yes/no questions
"hi Search      ctermfg=white ctermbg=magenta cterm=underline,bold
hi Search       ctermfg=black ctermbg=brown
hi SpecialKey   ctermfg=darkgrey ctermbg=none cterm=bold
hi StatusLine   ctermfg=green ctermbg=darkgrey cterm=bold
hi StatusLineNC ctermfg=magenta ctermbg=darkgrey cterm=bold
"hi Title       titles for output from ":set all", ":autocmd" etc.
hi Visual       ctermfg=white ctermbg=magenta cterm=bold
"hi VisualNOS   Visual mode selection when vim is "Not Owning the Selection".  Only X11 Gui's |gui-x11| and |xterm-clipboard| supports this.
"hi WarningMsg  warning messages
"hi WildMenu    current match in 'wildmenu' completion

" statline plugin
hi link User1   Identifier
hi link User2   Statement
hi link User3   Error
hi link User4   Special
