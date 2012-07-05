" vim: set ts=2 sts=2 sw=2 expandtab smarttab fdm=marker:
"this file works with unix.  you should too.
"
" TODO: learn more about tabs, tags, quickfix, loc list, plugins...
" things to remember: tildeop...

set nocompatible   " set this first as it can change other things

if version < 700
  echoerr "this vimrc requires vim 7"
endif

set     encoding=utf-8
set termencoding=utf-8

" this should be the default (with LANG=en_US.utf-8)
setglobal fileencodings=ucs-bom,utf-8,default,latin1

" [ options ] {{{1
set   autoindent
set noautowrite    " i should probably turn this on
set   backspace=indent,start " allow backspacing over indent and start of insert (but not eol)
set   background=dark
set   completeopt=menuone,preview " show menu even with only one match
set   foldcolumn=2 " width
set noequalalways  " don't resize windows when i split, just split
set   esckeys      " allow arrow keys to work in insert mode (adjust timeoutlen if necessary)
set nogdefault     " disable this, but it's an interesting option to remember
set   hidden       " when closing a window hide it instead of unloading it
"set history=100
set   hlsearch     " hightlight matches when searching
set noincsearch    " too jumpy
set   joinspaces   " 2 spaces after punctuation when joining lines
set   laststatus=2 " always show statusline
set nolazyredraw   " TODO: reconsider this
set   list         " show invisible chars ('listchars')
set   listchars=tab:▸\ ,extends:⇢,precedes:⇠,nbsp:☐,trail:⬚ "eol:¬, " hooray for unicode
set   magic        " too bad there's no set verymagic (but good for compatibility)
set   matchpairs+=<:>
set nomore         " don't give more-style prompts, i use tmux
set   nrformats=octal,hex,alpha
set   number       " show line numbers
set   report=0     " show number of lines changed by a command
set   scrolloff=2  " show lines of context around cursor at top or bottom of screen
set nostartofline  " keep column position when jumping
set   shiftround   " >> to even numbered columns
set   shortmess=atToO " shorten file info messages
set   showcmd      " show unfinished command in the command line (right side)
set   showmode     " show vim mode at the bottom (insert/replace/visual)
"set   switchbuf=   " default is blank, but usetab could be interesting
set   textwidth=0  " don't wrap automatically
set   timeout timeoutlen=3000 ttimeoutlen=100 " try to detect term keys but give me 3 sec to finish my command
set   wildmenu     " completion menu
set   wildmode=longest:full,full " complete 'til longest common string, then open menu

" combo options
set noexpandtab nosmarttab " off by default, enabled by filetype plugins
set ignorecase smartcase " searching for lowercase is case-insensitive (use \c \C to override)
set noshowmatch matchtime=1 " on insert highlight matching bracket for 0.x seconds

" currently undecided on 'formatoptions' and 'cpoptions'

" customize statusline {{{2
function! StatusLineFileAttr()
  return "(ft=" . &filetype . " fenc=" . &fileencoding . (&fileformat != "unix" ? " ff=" . &fileformat : "") . ")"
endfunction
" don't want stl=%!func() b/c it re-evaluates with each C-W (and vars get confused)
set statusline=%<%f\ \ %{StatusLineFileAttr()}\ \ %h%m%r\ %=\ buf#%n\ \ %-14.(%l/%L,%c%V%)\ %P
" }}}2
" }}}1

filetype off " turn off to load plugins (we turn it on later)

" [ plugins ] {{{1
" git clone https://github.com/gmarik/vundle ~/.vim/bundle/vundle/
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

" TODO: consider these:
" https://github.com/zaiste/vimified
" https://github.com/mutewinter/dot_vim
" vimscripts: 'L9' + 'FuzzyFinder'

" enable repeating certain plugin actions with .
Bundle 'tpope/vim-repeat'

" view images
Bundle 'tpope/vim-afterimage'
" toggle comment state with \\
Bundle 'tpope/vim-commentary'
" navigate various things back and forth with [x and ]x (t,l,q...)
Bundle 'tpope/vim-unimpaired'

" cursor jump selection with \\w or \\f
Bundle 'Lokaltog/vim-easymotion'

" file browser
Bundle 'scrooloose/nerdtree'
"function StartUp() | if 0 == argc() | NERDTree | end | endfunction
"autocmd VimEnter * call StartUp()

" [ git ] {{{2
" get the latest fixes for vim files
Bundle 'tpope/vim-git'
" powerful git integration
Bundle 'tpope/vim-fugitive'
" }}}2

" [ perl ] {{{2
" use ack as &grepprg
Bundle 'mileszs/ack.vim'

" syntax and ftplugin files for perl (plus pod, tt2...)
Bundle 'petdance/vim-perl'
" syntax files for CPAN::Changes
Bundle 'rwstauner/vim-cpanchanges'

" enable :Perldoc command (via Pod::Simple::Vim)
"let g:Perldoc_path = expand("~/.vim/cache/perldoc/")
"Bundle 'PERLDOC2'

" prove the current file and put colored results in a special window
"Bundle 'motemen/tap-vim'
" enable :make to run prove and put test failures in the quickfix
Bundle 'perlprove.vim'
  au BufRead,BufNewFile *.t set filetype=perl | compiler perlprove
" }}}2

" [ syntastic ] automatic syntax check into location list {{{2
let g:syntastic_check_on_open=0 " avoid start-up delay; check on save, not open
let g:syntastic_auto_jump=0
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=5
"let g:syntastic_mode_map = { 'mode': 'active', \ 'active_filetypes': ['ruby', 'php'], \ 'passive_filetypes': ['puppet'] }
let g:syntastic_quiet_warnings=0
let g:syntastic_stl_format='[Syntax: %E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
Bundle 'scrooloose/syntastic'
" }}}2

" [ statline ] override statusline with something more powerful {{{2
" TODO: compare to https://github.com/Lokaltog/vim-powerline
let g:statline_syntastic = 1
let g:statline_fugitive = 1
let g:statline_show_n_buffers = 1
let g:statline_show_encoding = 1
let g:statline_no_encoding_string = 'ascii'
let g:statline_filename_relative = 1
let g:statline_trailing_space = 1
let g:statline_mixed_indent = 1
" someday i might actually want these (for $work) but we're not using them yet
" could add something similar for perlbrew but I don't know what I'd want yet
let g:statline_rvm = 0
let g:statline_rbenv = 0
Bundle 'millermedeiros/vim-statline'
" }}}2

" [ slime ] pass vim text to a repl via terminal multiplexer {{{2
if $MULTIPLEXER != ""
  let g:slime_target = $MULTIPLEXER
  let g:slime_paste_file = tempname() | " my tmux has issues with pipes
  Bundle 'jpalardy/vim-slime'
endif
" }}}2
" }}}1

command SourceCodeStyle setlocal ts=2 sts=2 sw=2 expandtab smarttab

" [ tags ] {{{1
"set tags+=~/.vim/tags/ptags " cpan: Vim::Tags
command -nargs=1 -complete=tag SpTag new | tag <args>
nmap <Leader>[t :sp +tN<CR>
nmap <Leader>]t :sp +tn<CR>
" I'd like a plugin that explores my whole tags file, but these only operate
" on the current buffer (which I haven't found useful yet)
"Bundle 'taglist.vim'
"Bundle 'majutsushi/tagbar'
" }}}1

" [ misc ]

"use this to keep screen from hanging on load, but set it back so i can use mouse wheel and click to select windows (hooray for hacks)
"set ttymouse=xterm2
"set mouse=a
"set ttymouse=xterm

"for TOhtml
let use_xhtml = 1
let html_use_css = 1
let html_no_pre = 1

"my variables
let s:historyLength=100
"let s:TabWidthVal=2
let s:dynamicHighlight=0

" [ term ] {{{1
" fix ctrl-arrow to work in command line mode (:help term.txt)
" vim doesn't have t_XX codes for C-arrow but S-arrow performs the same function
set t_#4=[1;5D
set t_%i=[1;5C
" make ctrl-pg up/down cycle tabs like they're supposed to
"set t_K3=[5;5~
"set t_K5=[6;5~
"nmap <kPageUp>   gT
"nmap <kPageDown> gt

" don't clear the screen (no termcap) when exiting vim or executing external commands
set t_ti= t_te=

" 256 color detection works
" (at least with gnome-terminal TERM=xterm-256color tmux TERM=screen-256color)

" 16 colors
"if has("terminfo")
"	set t_Co=16
"	set t_AB=[%?%p1%{8}%<%t%p1%{40}%+%e%p1%{92}%+%;%dm
"	set t_AF=[%?%p1%{8}%<%t%p1%{30}%+%e%p1%{82}%+%;%dm
"else
"	set t_Co=16
"	set t_Sf=[3%dm
"	set t_Sb=[4%dm
"endif
"" 8 colors
"if &term =~ "xterm"
"	if has("terminfo")
"		set t_Co=8
"		set t_Sf=[3%p1%dm
"		set t_Sb=[4%p1%dm
"	else
"		set t_Co=8
"		set t_Sf=[3%dm
"		set t_Sb=[4%dm
"	endif
"endif
" }}}1

"give me the Man command (but I'll just use the one that comes with)
if exists(":Man") != 2
	com -nargs=+ Man call ManDelay(<f-args>)
	function ManDelay (cmd)
		let manplugin = expand("$VIMRUNTIME/ftplugin/man.vim")
		if filereadable(manplugin)
			echo "loading Man plugin..."
			delcommand Man
			exe "source " . manplugin
			exe "Man " . a:cmd
      " we're in the "man" window now
      set nonumber
		else
			echoe "Man plugin not found"
		endif
	endfunction
end

"remap things i don't like (although aterm doesn't let me use these anyway)
map <S-Down> 	V<Down>
map <S-Up> 		V<Up>

" suggested by motion.txt
":map [[ ?{<CR>w99[{
":map ][ /}<CR>b99]}
":map ]] j0[[%/{<CR>
":map [] k$][%?}<CR>

" highlight conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
" highlight todo messages in any syntax
match ToDo "\c\v(TODO|FIXME|NOTE|XXX|HACK|TBD|EXPERIMENTAL|BODGE)"

if $SOLARIZED > 0
  Bundle 'altercation/vim-colors-solarized'
  let g:solarized_termtrans=1
  if $SOLARIZED == 256
    let g:solarized_termcolors=256
  endif
  colorscheme solarized
elseif filereadable(expand("~/.vim/colors/wounded.vim")) | colorscheme wounded | endif

syntax enable
filetype indent plugin on

let perl_include_pod = 1
let perl_extended_vars = 1
let perl_string_as_statement = 1
let perl_want_scope_in_variables = 1
"let perl_fold = 1
"let perl_fold_blocks = 1
let python_highlight_all = 1


"autocommands for specific file types
"when i set textwidth to 0, i want it to be 0!
autocmd! BufRead *.txt
	"back to the line where i was last time, please
autocmd  BufReadPost * 	if line("'\"") > 0 && line ("'\"") <= line("$") | exe "normal g'\"" | endif

"autocmd  BufNewFile,BufNew * 								call TabWidth(4)
"autocmd  BufNewFile,BufRead *								call TabWidth(4)
"autocmd  BufNewFile,BufRead crontab,crontab.* 				call TabWidth(8)
"autocmd  BufRead * 											if &filetype == "xinetd" | call TabWidth(8) | endif
autocmd  Syntax,FileType *.pl 								let perl_sync_dist = 2000
"au! FileType perl :noremap <leader>w \ :!time perl -Mwarnings::unused -MVi::QuickFix -c %<cr>

" Readline, please
cnoremap <C-A>		<Home>
"cnoremap <C-D>		<Del>
cnoremap <C-E>		<End>

"command aliases
"stupid fingers (either too fast or too slow...)
command -nargs=? -complete=dir -complete=file W w <args>
command -nargs=+ -complete=dir -complete=file Grep execute "grep " . (<q-args>) | copen
command -bang Q q<bang>
command -bang Qall qall<bang>
command Wq wq
command WQ wq
command Wn wn
command WN wN
command Args args
command -nargs=? -complete=dir -complete=file Sp sp <args>
command Mkpath !mkdir -p %:h
command MkPath Mkpath

command EightyCharacters call MaxLineLength(80)
command -nargs=? MaxLineLength call MaxLineLength(<args>)
command ModeLine exe "norm O" . printf(&cms, " vim: set ts=2 sts=2 sw=2 expandtab smarttab:")
"
" using named register ("p) is easier than escaping expr reg ("=)
"command! -nargs=1 -complete=expression Put let @p = <args> | put p
command! -nargs=1 -complete=expression Put call append(".", <args>)

command -nargs=1 -complete=option 	Set 	set <args>
command -nargs=1 -complete=file 	Echo 	echo <q-args>
command -nargs=1 -range				PerlDo 	call PerlDo(<q-args>)
command -nargs=1 -complete=file 	Rename 	call RenameCurrent(<q-args>)
command -nargs=+ -range 			CommentSection call CommentSection(<f-args>)

command -nargs=1 FoldComments	call FoldComments(<f-args>)
command -nargs=+ Highlight		call Highlight(<f-args>)
command -nargs=1 TabWidth 		call TabWidth(<f-args>)
if exists("+cursorline")
	command HighlightPosition 	set cursorcolumn! | set cursorline!
endif

command -nargs=1 -complete=dir -complete=file Arge 99arge <args>
command -nargs=+ -complete=custom,XMLargumentCompletion		Xt 	call XMLtag(0,<f-args>)
command -nargs=+ -complete=custom,XMLargumentCompletion -range 	Xv	call XMLtagV(<f-args>)
command -nargs=+ -complete=custom,XMLargumentCompletion		Xa	call XMLattr(<f-args>)

command SynStack for id in synstack(line("."), col(".")) | echo synIDattr(id, "name") . " => " . synIDattr(synIDtrans(id), "name") | endfor
command XMLmode call XMLmode()

command -range=% TabbedToAsciiTable <line1>,<line2>! perl -MText::ASCIITable -e '$t = Text::ASCIITable->new; $t->setCols(split(/\t/, scalar <STDIN>)); $t->addRow(split(/\t/)) for <STDIN>; print $t'

"all hail the glorious mappings
"<Leader> == mapleader (default"\")
"goto file by adding it to the argument list
nmap <Leader>f 			:call ArgeCfile()<CR>
nmap <Leader>F 			:99arge <cfile><CR>
"space a line
nmap <Leader>o			:call <SID>DoubleSpace("n")<CR>
vmap <Leader>o			<Esc>:call <SID>DoubleSpace("v")<CR>
nmap <Leader>J			gJkgJ
"CamelCase -> underscore
nmap <silent> <Leader>_ 	i_gu2l
vmap <silent> <Leader>_ 	<Esc>:set lz<CR>`>a`<i:s/\v([a-z])([A-Z])/\1_\l\2/g<CR>gJkgJ:set nolz<CR>:redraw<CR>:silent noh<CR>
"mappings for dynamic characters
map  <silent> <Leader>! 	:call Bang()<CR>
nmap <silent> <Leader>b 	:call InBetween("",0)<CR>
nmap <silent> <Leader>B 	:call InBetween("",1)<CR>
nmap <silent> <Leader>c 	:call InBetween("c",0)<CR>
nmap <silent> <Leader>C 	:call InBetween("c",1)<CR>
nmap <silent> <Leader>d 	:call InBetween("d",0)<CR>
nmap <silent> <Leader>D 	:call InBetween("d",1)<CR>
nmap <silent> <Leader>x 	:call InBetween("x",1)<CR>
nmap <silent> <Leader>X 	:call InBetween("x",0)<CR>
nmap <silent> <Leader>v 	:call InBetween("v",0)<CR>
nmap <silent> <Leader>V 	:call InBetween("v",1)<CR>
nmap <silent> <Leader>y 	:call InBetween("y",0)<CR>
nmap <silent> <Leader>Y 	:call InBetween("y",1)<CR>
nmap <silent> <Leader>s 	:<C-U>call SurroundCword(0)<CR>
nmap <silent> <Leader>S 	:<C-U>call SurroundCword(1)<CR>
nmap <silent> <Leader>t 	:<C-U>call SurroundTill(0,0)<CR>
nmap <silent> <Leader>T 	:<C-U>call SurroundTill(0,1)<CR>
nmap <silent> <Leader>r 	:<C-U>call SurroundTill(1,1)<CR>
nmap <silent> <Leader>R 	:<C-U>call SurroundTill(1,0)<CR>
vmap <silent> <Leader>s 	:call SurroundSelection()<CR>
"POD formatting codes
nmap <silent> <Leader>p 	:<C-U>call SurroundCword(0,"<",">","F<i".toupper(nr2char(getchar())))<CR>
nmap <silent> <Leader>P 	:<C-U>call SurroundCword(1,"<",">","F<i".toupper(nr2char(getchar())))<CR>
vmap <silent> <Leader>p 	:call SurroundSelection("<",">","i".toupper(nr2char(getchar())))<CR>
"C-style multiline comments
nmap <Leader>* 			A */<Esc>I/* <Esc>l
vmap <silent> <Leader>* 	:call SurroundSelection( "/* ", " */" )<CR>
nmap <silent> <Leader>8 	:call UnComment( 1, "/*", "*/" )<CR>
vmap <silent> <Leader>8 	:call UnComment( 0, "/*", "*/" )<CR>
"POD
nmap <silent> <Leader>= 	:call Pod("n")<CR>
vmap <silent> <Leader>= 	:call Pod("v")<CR>
"character manipulation
"nmap <silent> <Leader>cs 	:call SpanishCharacters(    )<CR>
"nmap <silent> <Leader>ch 	:call HtmlEscape(    )<CR>
" html paragraph
"nmap <silent> <Leader>hp 	:call XMLtag( 0, "p" )<CR>
"nmap <silent> <Leader>hP 	:call XMLtag( 1, "p" )<CR>
nmap <silent> <Leader>hp 	:norm {o<p>}O</p>
nmap <silent> <Leader>hP 	:norm o</p>oo<p>
vmap <silent> <Leader>hp 	:call XMLtagV(   "p" )<CR>
" html div
nmap <silent> <Leader>hd 	:norm {o<div>}O</div>
nmap <silent> <Leader>hD 	:norm o</div>oo<div>
"html tags
nmap <silent> <Leader>hb 	:call XMLtag( 0, "b" )<CR>
nmap <silent> <Leader>hB 	:call XMLtag( 1, "b" )<CR>
vmap <silent> <Leader>hb 	:call XMLtagV(   "b" )<CR>
nmap <silent> <Leader>he 	:call HtmlEscape(    )<CR>
nmap <silent> <Leader>hi 	:call XMLtag( 0, "i" )<CR>
nmap <silent> <Leader>hI 	:call XMLtag( 1, "i" )<CR>
vmap <silent> <Leader>hi 	:call XMLtagV(   "i" )<CR>
nmap <silent> <Leader>hu 	:call XMLtag( 0, "u" )<CR>
nmap <silent> <Leader>hU 	:call XMLtag( 1, "u" )<CR>
vmap <silent> <Leader>hu 	:call XMLtagV(   "u" )<CR>
nmap <silent> <Leader>hs 	:call XMLtag( 0, "span", "class" )<CR>
nmap <silent> <Leader>hS 	:call XMLtag( 1, "span", "class" )<CR>
vmap <silent> <Leader>hs 	:call XMLtagV(   "span", "class" )<CR>
vmap <silent> <Leader>hS 	:call XMLtagV(   "span" )<CR>
nmap <silent> <Leader>hc 	:call XMLattr(   "class" )<CR>
nmap <Leader>hr 		i<lt>br /><Esc>
nmap <Leader>hR 		A<lt>br /><Esc>
nmap <Leader>hh 		i<lt>hr /><Esc>
nmap <Leader>hH 		A<lt>hr /><Esc>
nmap <Leader>h! 		A --><Esc>I<!-- <Esc>l
vmap <silent> <Leader>h!	:call SurroundSelection( "<!-- ", " -->" )<CR>
nmap <silent> <Leader>h1	:call UnComment( 1, "<!--", "-->" )<CR>
vmap <silent> <Leader>h1	:call UnComment( 0, "<!--", "-->" )<CR>
"upper and lower case current word or selection
nmap <Leader>u 			wgUbe
nmap <Leader>l 			wgube
nmap <Leader>U 			WgUBE
nmap <Leader>L 			WguBE
vmap <Leader>u 			<Esc>`>gUlgU`<
vmap <Leader>l 			<Esc>`>gulgu`<
"surround character/selection with spaces
nmap <Leader><space> 		i <Esc>la <Esc>
vmap <Leader><space> 		`>a <Esc>`<i <Esc>
"clone(gemini) current character,word,selection
nmap <Leader>gc			ylp
nmap <Leader>gw			wbywep
nmap <Leader>gW			WByWEp
vmap <Leader>g 			y`>p
"search for the current selection ('as is')
vmap <Leader>/ 			yq/p0i\V


" Ovid: show first commit where term under cursor was added
" http://twitter.com/OvidPerl/status/28395223746875392
nmap <leader>1 :!git log --reverse -p -S<cword> %<cr>
" Ovid: handy if hacking urls
" http://twitter.com/OvidPerl/status/28076709865586688
vnoremap <leader>un :!perl -MURI::Escape -e 'print URI::Escape::uri_unescape(do { local $/; <STDIN> })'<cr>

"and the almighty functions
function ArgeCfile() "open filename under cursor at the end of the current argument list.
	let edit_cmd = ":99arge "
	"allow all the coolness of the gf command, but don't go losing files
	norm gf
	exe edit_cmd . "%"
	return
"	"find cursor file relative to current file
"	let adddir = fnamemodify( expand("%"), ":p:.:h")
"	if adddir != ""
"		let adddir = adddir . "/"
"	endif
"	let addfile = simplify( adddir . expand("<cfile>") )
"
"	if filereadable(addfile)
"		execute edit_cmd . addfile
"	else
"		let addfile = simplify( expand("<cfile>:p:.") )
"		"let addfile = simplify( expand("%:p:h") . "/" . expand("<cfile>") )
"		if filereadable(addfile)
"			execute edit_cmd . addfile
"		else
"			echoe "File Not Found"
"		endif
"	endif
endfunction
function Bang() range "external commands
	let commandchar = nr2char( getchar() )
	if commandchar == "x"
		let commandarg = nr2char( getchar() )
		let i = 1
		while i <= v:count1
			let i = ( i + 1 )
			execute ":silent ! ~/bin/xmmskeys -" . commandarg 
			redraw!
		endwhile
	endif
endfunction

function CleanupWordPaste() range
"	'<,'>s/–/.../g
	'<,'>s/–/--/g
	'<,'>s/’/'/g
	'<,'>s/[“”]/"/g
endfunction

"Csomething generally means current something
function Cline(...) "offset (-above or +below cursor)
	return getline(line(".") + ( a:0 ? a:1 : 0))
endfunction
function Cchar(...) "offset (-left or +right of cursor)
	return getline(line("."))[col(".") - 1 + ( a:0 ? a:1 : 0)]
endfunction
function Cword(...) "unrestrictive boundaries
	return expand( "<c" . ( a:0 && a:1 ? "WORD" : "word" ) . ">" )
endfunction

function CommentSection(section, ...) range
	if a:0 >= 1
		let comment_start = a:1
	elseif &filetype == "sql"
		let comment_start = "--"
	elseif &filetype == "vim"
		let comment_start = "\""
	elseif &filetype == "javascript" || &filetype == "c" || &filetype == "cpp"
		let comment_start = "//"
	else
		let comment_start = "#"
	endif
	if a:0 >= 2
		let comment_end = " " . a:2
	else
		let comment_end = ""
	endif

	let section = "[" . a:section . "]"
	exe "norm '>o" . comment_start . " } " . section .        comment_end
	exe "norm '<O" . comment_start . " "   . section . " {" . comment_end
endfunction

function <SID>DoubleSpace(mode)
	let leader_o_col = col(".")
	if a:mode == "v"
		" it's consistent to simply end up at the top
		norm '>o'<Oj0
	else
		norm    okOj0
	end
	if leader_o_col > 1
		exe "norm " . (leader_o_col - 1) . "l"
	endif
endfunction

function MaxLineLength(...) " default 80 characters
	exe "match ErrorMsg '\\%>" . (a:0 >= 1 ? a:1 : 80) . "v.\\+'"
endfunction

function FoldComments(singleline) "Create folds of consecutive commented lines by sending singleline comment starter
	set foldmethod=expr
	execute "set foldexpr=getline(v:lnum)=~\\\"^" . a:singleline . "\\\""
endfunction
function Highlight(hl, ...)
	let s:dynamicHighlight = s:dynamicHighlight + 1
	let dhlmatch = "dynamicHighlight" . s:dynamicHighlight
	exe "syn match " . dhlmatch . " \"" . (&ignorecase ? "\\c" : "") . a:hl . "\""
	exe "hi! link  " . dhlmatch . " " . ( a:0 >= 1 ? a:1 : "Identifier" )

	"pretty much just an argument swap
	"exe "match " . ( a:0 >= 1 ? a:1 : "Identifier" ) . " /" . a:hl . "/"
endfunction

"html
function HtmlEscape(...) "range
	let oldreg = getreg('"') "preserve my previous yanking

	let reg = 'h'
	exe 'norm "' . reg . 'yl'
	let c = getreg(reg)

	let entities = { '&': 'amp', '<': 'lt', '>': 'gt', ' ': 'nbsp', '"': 'quot' }
	if has_key(entities, c)
		exe 'norm "_cl&' . entities[c] . ';'
	endif
	unlet entities

	call setreg('"', oldreg) "preserve my previous yanking
endfunction
"	function FancyCharacters(...) "range
"		let oldreg = getreg('"') "preserve my previous yanking
"	
"		let reg = 'c'
"		exe 'norm "' . reg . 'yl'
"		let c = getreg(reg)
"	
"		" …“”’–
"		let entities = {'…': '...', '“': '"', '”': '"', "’": "'", '–': '--'}
"		" insert using vim utf-8 escape sequence
"		"if has_key(entities, c)
"			"exe 'norm "_clu00' . entities[c]
"		"endif
"		unlet entities
"	
"		call setreg('"', oldreg) "preserve my previous yanking
"	endfunction
"	function SpanishCharacters(...) "range
"		let oldreg = getreg('"') "preserve my previous yanking
"	
"		let reg = 'c'
"		exe 'norm "' . reg . 'yl'
"		let c = getreg(reg)
"	
"		let entities = {'a': 'E1', 'e': 'E9', 'i': 'ED', 'n': 'F1', 'o': 'F3', 'u': 'FA', 'U': 'FC', '!': 'A1', '?': 'BF'}
"		" insert using vim utf-8 escape sequence
"		if has_key(entities, c)
"			exe 'norm "_clu00' . entities[c]
"		endif
"		unlet entities
"	
"		call setreg('"', oldreg) "preserve my previous yanking
"	endfunction
function ImageDataUri() range
	"echoerr if perl -MFile::Type -e 'print 1' != "1"
	set lz
	norm `>a
	norm `<i
	norm Icurl -s "A" | perl -MMIME::Base64 -0777 -MFile::Type -ne '($b = encode_base64($_)) =~ s/\n//g; print "data:" . File::Type->new->mime_type($_) . ";base64," . $b;'
	"norm $T.yekAdata:image/pA;base64,
	. ! /bin/bash
	norm gJkgJ
	set nolz
	redraw!
endfunction

function InBetween(cmd, inclusive, ...) "grab-command ([dxy]), inclusive, leftside, rightside
	let cmd = ( a:cmd != "" ? a:cmd : nr2char( getchar() ) )
	if a:inclusive
		let tillright = "f"
		let tillleft = "F"
	else
		let tillright = "t"
		let tillleft = "T"
	endif
	let startpos = col(".")
	let leftside = ( a:0 >= 1 ? a:1 : nr2char( getchar() ) )
	let rightside = ( a:0 >= 2 ? a:2 : MatchPair( leftside ) )
"	if Cchar() != rightside
"		execute "normal d" . tillright . rightside
"		call cursor(0, startpos)
"	endif
"	if Cchar() != leftside
"		execute "normal d" . tillleft . leftside . ( col(".") == startpos - 1 ? "x" : "" )
"	endif
	if Cchar() != leftside || ( leftside == rightside && stridx( strpart( Cline(), startpos ), rightside ) == -1 )
		execute "normal " . tillleft . leftside
	endif
		execute "normal " . ( cmd ) . tillright . rightside . ( cmd != "x" ? "" : "x" )
	if cmd == "c"
		normal l
		startinsert
	endif
endfunction

function LoadSyntax(...)
	let l:syn = a:0 > 0 ? a:1 : "tt2"
	let l:bcs = b:current_syntax
	unlet b:current_syntax
	exe "runtime! syntax/" . l:syn . ".vim"
	let b:current_syntax = l:bcs
endfunction

function MatchPair( character ) "find the complement to a given character (or return given character)
	let symbol = stridx( "([{<>}])", a:character )
	return symbol > -1 ? strpart( ")]}><{[(", symbol, 1 ) : a:character
endfunction
function PerlDo(pl) range
  "let l:oldpaste = &paste
  set paste
	norm `>ak
	let l2 = line('.') + 1 " next we'll drop them all down by one
	norm `<i
	let l1 = line('.')
	exe l1 . "," . l2 . "perldo " . a:pl
	exe l2
	norm gJ
	exe l1
	norm kgJ
  set nopaste
endfunction
function Pod(mode) range "vi mode
	let podstyle = nr2char( getchar() )
	if podstyle == "p"
		let startcmd = "O=pod"
		let endcmd = "o=cut"
		let podaction = 1
	elseif podstyle == "r"
		let startcmd = "O=begin"
		let endcmd = "o=end"
		let podaction = 1
	"elseif podstyle == "#" or podstyle == "3"
		"startcmd = "O=begin"
		"endcmd = "o=end"
	"elseif podstyle == "d" or podstyle == "x"
	else
		return
	endif
		
	if podaction == 1
		if a:mode == "v"
			execute "normal \e`>" . endcmd . "\e`<" . startcmd . "\e"
		else
			execute "normal " . startcmd . "\e" . (v:count + 1) . "j" . endcmd . "\e"
		endif
	endif
		"execute "normal \e`>" . ( ( i - 1 ) > 0 ? 2 * ( i - 1 ) . "l" : "" ) . ( a:0 >= 3 ? a:3 : "" ) . "a" . rightside . "\e`<" . ( a:0 >= 4 ? a:4 : "" ) . "i" . leftside  
		"execute "normal \e" . ( a:0 >= 4 ? a:4 : "" ) . "`>a" . rightside . "\e`<" . "i" . leftside . "\e" . ( a:0 >= 3 ? a:3 : "" ) 
endfunction

function RenameCurrent(name)
	let name = a:name
	if match(name, "/") == -1
		let name = expand("%:h") . "/" . name
	end
	call rename(expand("%"), name)
	exe "edit " . name
endfunction

function SurroundCword(...) range "unrestrictiveboundaries, leftside, rightside, endcommands, startcommands
	let leftside = ""
	let rightside = ""
	let i = 1
	while i <= v:count1
		let thischar = ( a:0 >= 2 ? a:2 : nr2char( getchar() ) )
		let leftside = leftside . thischar
		let rightside = ( a:0 >= 3 ? a:3 : MatchPair( thischar ) ) . rightside 
		let i = ( i + 1 )
	endwhile
		if Cchar() !~ "\\s" && Cline() != "\0" 	"if cursor is over a word (not a space or a blank line)
			let rBounds = ( a:0 >= 1 && a:1 ? 1 : 0 )
			if rBounds			"and boundaries are relaxed
				let beginBound = "B"
				let endBound = "E"
			else
				let beginBound = "b"
				let endBound = "e"
			endif
			let surround = "w" . beginBound . "i" . leftside . "\e" . endBound . "a" . rightside . "\e" 
			"add start and end commands if present
			exe "normal " . ( a:0 >= 5 ? a:5 : "" ) . surround . ( a:0 >= 4 ? a:4 : beginBound . ( rBounds ? strlen( leftside ) . "l" : "" )  ) . "\e"
		else
			let surround = "i" . leftside . rightside . "\e"
			let rightsidelen = ( strlen( rightside ) - 1 )
			execute "normal " . surround . ( rightsidelen ? rightsidelen . "h" : "" ) . "\e"
		endif
endfunction
function SurroundSelection(...) range "leftside, rightside, endcommands, startcommands
	let leftside = ""
	let rightside = ""
	let i = 1
	while i <= v:count1
		let thischar = ( a:0 >= 1 && a:1 != "" ? a:1 : nr2char( getchar() ) )
		let leftside = leftside . thischar 
		let rightside = ( a:0 >= 2 && a:2 != "" ? a:2 : MatchPair( thischar ) ) . rightside
		let i = ( i + 1 )
	endwhile
		"execute "normal \e`>" . ( ( i - 1 ) > 0 ? 2 * ( i - 1 ) . "l" : "" ) . ( a:0 >= 3 ? a:3 : "" ) . "a" . rightside . "\e`<" . ( a:0 >= 4 ? a:4 : "" ) . "i" . leftside  
		execute "normal \e" . ( a:0 >= 4 ? a:4 : "" ) . "`>a" . rightside . "\e`<" . "i" . leftside . "\e" . ( a:0 >= 3 ? a:3 : "" ) . "\e"
endfunction
function SurroundTill(r, ...) range "replace, tilloutside(farther), till, leftside, rightside
	let tillcmds = ""
	if a:0 >= 1 && a:1
		let tillright = "f"
		let tillleft = "F"
	else
		let tillright = "t"
		let tillleft = "T"
	endif
	let startpos = col(".")
	let leftside = ""
	let rightside = ""
	let tilltoleft = ( a:0 >= 2 ? a:2 : nr2char( getchar() ) )
	let tilltoright = MatchPair( tilltoleft )
	let i = 1
	while i <= v:count1
		let thischar = ( a:0 >= 3 ? a:3 : nr2char( getchar() ) )
		let leftside = leftside . thischar 
		let rightside = ( a:0 >= 4 ? a:4 : MatchPair( thischar ) ) . rightside
		let i = ( i + 1 )
	endwhile
	let tillrightcmd = "normal " . tillright . tilltoright . ( a:r ? "cl" : "a" ) . rightside . "\e"
	let tillleftcmd = "normal " . tillleft . tilltoleft . ( a:r ? "cl" : "i" ) . leftside . "\e"
	if Cchar() == tilltoleft || Cchar() == tilltoright
		if stridx( Cline(), tilltoright ) > col(".")
			execute "normal " . ( tillright == "t" ? "a" : "i" ) . leftside . "\e"
			execute tillrightcmd
		else
			execute "normal " . ( tillright == "t" ? "i" : "a" ) . rightside . "\e"
			call cursor(0, startpos)
			execute tillleftcmd
		endif
	else
		execute tillrightcmd
		call cursor(0, startpos)
		execute tillleftcmd
	endif
endfunction

function TabWidth(width) "change tab display width
	execute ":set shiftwidth=" . a:width
	execute ":set softtabstop=" . a:width
	execute ":set tabstop=" . a:width
endfunction

function UnComment(force, cstart, cend) range "forceall, comment start, comment end
	if a:force
		execute ":" . a:firstline . "," . a:lastline . "sno@\\( \\?" . a:cstart . " \\?\\| \\?" . a:cend . " \\?\\)@@ge"
	else
		let i = a:firstline
		let removedstart = 0
		let removedend = 0
		while i <= a:lastline
			let commentindex = stridx( getline(i), a:cstart )
			if commentindex > -1 && commentindex >= ( col("'<") - 1 )
				"setline()
				execute ":" . i . "sno@ \\?" . a:cstart . " \\?@@e"
				let removedstart = 1
			endif
			let commentindex = stridx( getline(i), a:cend )
			if commentindex > -1 && commentindex <= col("'>")
				execute ":" . i . "sno@ \\?" . a:cend . " \\?@@e"
				return
				let removedend = 1
			endif
			let i = ( i + 1 )
		endwhile
		if ! removedend
			execute "normal `>a " . a:cstart . " \e"
		endif
		if ! removedstart
			execute "normal  `<i " . a:cend . " \e"
		endif
	endif
	silent noh
endfunction

function XMLmode()
	" we need the g: global prefix b/c we're inside a function
	let g:xml_use_xhtml = 1
	"let g:xml_tag_completion_map = "<C-l>"
	if exists("b:did_ftplugin")
		unlet b:did_ftplugin
	endif
	let b:match_words = "XMLmodeMatchWords()"
	source $VIMRUNTIME/macros/matchit.vim
	source ~/.vim/macros/xml_xhtml.vim
	if ! (&filetype == "html" || &filetype == "xhtml")
		set filetype=xml
	endif
endfunction

function XMLmodeMatchWords()
	" jump from <tag> to </tag> by returning the tag you're currently on
	let cword = expand("<cword>")
	return "<:>,<" . cword . ":</" . cword . ">"
endfunction

function XMLattr(attr, ...) "attrname, value
	let attrtxt = a:attr . "=\"" . ( a:0 ? a:1 : "" ) . "\""
	if Cchar() == ">" || Cchar() == " "		"if at the end of the tag or on a space
		let attrcmd = "i " . attrtxt . "\e"
	elseif Cword(1)[0] == "<" 			"if in the start of the tag
		let attrcmd = ( Cchar() != "<" ? "B" : "") . "ea " . attrtxt . "\e"
	else						"if somewhere inside
		let attrcmd = ( Cchar(-1) == " " ? "" : "B" ) . "i" . attrtxt . " \eh"
	endif
		execute "normal " . attrcmd
endfunction
"	function XMLargumentCompletion(ArgLead, CmdLine, CursorPos)
"		"if filereadable("/usr/share/vim/vim*/syntax/html.vim")
"		"if filereadable("/usr/share/vim/vim*/syntax/cf.vim")
"		return "a\nb\ninput\nspan\ntable"
"		"let taglist = execute "syntax list cfTagName"
"		"$VIMRUNTIME/syntax/cf.vim
"		"runtime! syntax/<name>.vim
"		"return ArgumentCompletion("xml", a:ArgLead, a:CmdLine, a:CursorPos)
"	
"		"let cftags = substitute("cfabort cfapplet cfapplication cfassociate cfauthenticate cfbreak cfcache cfcol cfcollection cfcontent cfcookie cfdirectory cferror cfexit cffile cfform cfftp cfgrid cfgridcolumn cfgridrow cfgridupdate cfheader cfhtmlhead cfhttp cfhttpparam cfif cfelseif cfelse cfinclude cfindex cfinput cfinsert cfldap cflocation cflock cfloop cfmail cfmodule cfobject cfoutput cfparam cfpop cfprocparam cfprocresult cfquery cfregistry cfreport cfschedule cfscript cfsearch cfselect cfset cfsetting cfslider cfstoredproc cfswitch cfcase cfdefaultcase cftable cftextinput cfthrow cftransaction cftree cftreeitem cftry cfcatch cfupdate cfwddx cfdump cfsavecontent cffunction cfmailparam cfreturn cfargument cfqueryparam", " ", "\n", "g")
"	
"	endfunction
function XMLtag(...) "unrestrictive boundaries, tagname, attribute, value
	:call SurroundCword( a:1, "<" . a:2 . ( a:0 >= 3 ? " " . a:3 . "=\"" . ( a:0 >= 4 ? a:4 : "" ) . "\"" : "") .  ">", "</" . a:2 . ">", "B" . ( ( a:0 >= 3 ? strlen( a:3 ) : strlen( a:2 ) ) + 2 ) . "l" )
endfunction
function XMLtagV(htag, ...) range "tagname, attribute, value
	:call SurroundSelection( "<" . a:htag . ( a:0 >= 1 ? " " . a:1 . "=\"" . ( a:0 >= 2 ? a:2 : "" ) . "\"" : "") .">", "</" . a:htag . ">", ( a:0 >= 1 ? "h" : "l" ) )
endfunction

"	function ArgumentCompletion(which, ArgLead, CmdLine, CursorPos)
"		return "a\nb\ninput\nspan\ntable"
"	endfunction

"call TabWidth(s:TabWidthVal)
exe "set history=" . s:historyLength

" load project-specific vimrc
"if getcwd() != "/home/rando"
"  exe "source " . getcwd() . "/.vimrc"
"endif
