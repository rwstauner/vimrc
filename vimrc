" vim: set ts=2 sts=2 sw=2 expandtab smarttab fdm=marker:

if &compatible
  set nocompatible " set this first but only if needed to avoid side effects.
endif

if !exists("g:editor_only")
  let g:editor_only = 0
endif

let s:nvim = has('nvim')

if version < 700
  echoerr "this vimrc requires vim 7"
endif

let g:cache_prefix = expand("$HOME/.cache/" . (has('nvim') ? 'n' : '') . "vim-")
let s:cache = g:cache_prefix . "cache"

" [ encoding ] {{{

set     encoding=utf-8
" this should be the default (with LANG=en_US.utf-8)
setglobal fileencodings=ucs-bom,utf-8,default,latin1

" }}}
" [ whitespace defaults ] {{{
" Adjustments can be tuned in `filetype.vim` or `after/ftplugin/*`.
set ts=2 sts=2 sw=2 expandtab smarttab
" }}}
" [ options ] {{{

set   autoread     " re-read file if it was changed externally and there are no changes in vim
" TODO: maybe we only want autowrite on files in git?
set   autowrite    " write before :make or jumping to another file
set noautowriteall " i should probably turn this on
set   backspace=indent,start " allow backspacing over indent and start of insert (but not eol)
set   background=dark
set   cedit=     " key sequence to open the command line window when already in command mode
set   colorcolumn=+0 " highlight the column at &textwidth
set   completeopt=menuone,preview " show menu even with only one match
set   confirm      " prompt yes/no/cancel instead of denying :q with changes
set   display=lastline,uhex " show partial if lastline is too long, <xx> instead of ^x
let  &directory = g:cache_prefix . "tmp//" " Put swapfiles here (// for full path) so that they aren't in project dirs.
set nofileignorecase " DWIM (pretend mac is case sensitive to limit undesired results)
set   foldcolumn=2 " width
set   foldopen +=insert,jump " auto-open folds when inserting or jumping far
set noequalalways  " don't resize windows when i split, just split
if exists('&esckeys')
  set   esckeys      " allow arrow keys to work in insert mode (adjust timeoutlen if necessary)
endif
set nogdefault     " if enabled s///gg will disable but that's too unintuitive to make me want it atm
set   hidden       " when closing a window hide it instead of unloading it
set   history=500  " number of items to rememeber for ex commands and searches
set   hlsearch     " highlight matches when searching
set noincsearch    " too jumpy
set   isfname -==  " let me complete filenames as vars (VAR=filename)
set   joinspaces   " 2 spaces after punctuation when joining lines
set   laststatus=2 " always show statusline
set   lazyredraw   " don't redraw screen during macros
"set   linebreak    " has no effect when list is on
set   list         " show invisible chars ('listchars')
set   listchars=tab:▸\ ,extends:⇢,precedes:⇠,nbsp:▣,trail:▫ "eol:¬, " hooray for unicode
set   magic        " too bad there's no set verymagic (but good for compatibility)
set   matchpairs+=<:>
set   modeline     " ensure modelines are honored
set   more         " page large output so that the top doesn't drop off the alternate screen
set   mouse=       " disable mouse
set   nrformats=octal,hex,alpha
set   number       " show line numbers
"set   path+=./**   " search for files anywhere below current file's parent dir
set   report=0     " show number of lines changed by a command
set   scrolloff=2  " show lines of context around cursor at top or bottom of screen
"set   swapfile     " default on
set nostartofline  " keep column position when jumping
set   shiftround   " >> to even numbered columns
set   shortmess=atToO " shorten file info messages
set   showbreak=⦉  " show start of wrapped lines
set   showcmd      " show unfinished command in the command line (right side)
set   showmode     " show vim mode at the bottom (insert/replace/visual)
set   splitright splitbelow " change default split to append rather than prepend
"set   switchbuf=   " default is blank, but usetab could be interesting
set   timeout timeoutlen=3000 ttimeoutlen=100 " try to detect term keys but give me 3 sec to finish my command
set   tildeop      " make ~ an operator (that expects a motion command)
set   updatetime=2000 " ms to wait before CursorHold and writing swap to disk
set   wildmenu     " completion menu
set   wildmode=longest:full,full " complete 'til longest common string, then open menu
"set   wildignore+= " extra globs to ignore when doing file completion
set   winminheight=1 " leave x lines showing when shrinking windows
set   winminwidth=3  " ditto for columns: show more than foldcolumn
set   viminfo +=!,f1 " global (uppercase) vars, file marks

" combo options
set ignorecase smartcase " searching for lowercase is case-insensitive (use \c \C to override)
set noshowmatch matchtime=1 " on insert highlight matching bracket for 0.x seconds

let &shell="env PATH=" . expand('$PATH') . ' ' . &shell

" TODO: investigate 'cpoptions'

if s:nvim
  set scrollback=50000 " default is 10k, max is 100k
  let $VISUAL = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
  let $EDITOR = $VISUAL
endif

" Need to put this in the front so that it is checked before the "%f:%l:%c" in
" the middle.
let &errorformat = '%+G%.%#\ at\ %f:%l:%c,%+G%.%#\ at\ %f:%l,' . &errorformat

" }}}

let g:map_prefixes = ["n", "c", "o", "x", "s", "v", "l", "i"]
if s:nvim
  call add(g:map_prefixes, "t")
endif

if exists("g:idea")
  finish
endif

" Don't load other language syntax files when editing vim files.
let g:vimsyn_embed = 0 "  'pP' => p: perl, P: python

" [ undo ] {{{

" remember :display and redo-register

" :help undo-persistence
if exists("+undofile")
  set undofile
  let &undodir = g:cache_prefix . "undo" " dir must already exist
  au BufWritePre /tmp/* setlocal noundofile
endif

" :help clear-undo
command! ClearUndo call ClearUndo()
function! ClearUndo()
  let old_undolevels = &undolevels
  set undolevels=-1
  exe "normal a \<BS>\<Esc>"
  let &undolevels = old_undolevels
  unlet old_undolevels
endfunction

" }}}
" [ formatting ] {{{

set   autoindent   " use previous line's indentation
set nosmartindent  " braces sound ok but i use # for comments more often than #ifdef
" 'cindent' is off by default, but may be useful to turn on for some filetypes
" we call "filetype indent on" later so 'indentexpr' can be customized by ft ($VIMRUNTIME/indent/)

set   textwidth=80 " common long-line limit (some filetypes customize this)

" [ 'formatoptions' ] {{{
" `:help fo-table` for descriptions of tcroqwan2vblmMB1j
" Subtract options one at a time (`:help add-option-flags`).
set  formatoptions +=crqbl  fo -=t fo -=o fo -=w fo -=a
" j is new in Vim 7.4, so don't complain if it's not there.
silent! set formatoptions+=j
" i usually find 'o' more annoying than helpful
autocmd BufWinEnter * setlocal formatoptions -=o
" }}}

"set   formatprg=fmt " better gq c-indent formatting
" cinoptions+=l1

" }}}
" [ statusline ] {{{

if !g:editor_only
  function! StatusLineFileAttr()
    return "(ft=" . &filetype . " fenc=" . &fileencoding . (&fileformat != "unix" ? " ff=" . &fileformat : "") . ")"
  endfunction
  " don't want stl=%!func() b/c it re-evaluates with each C-W (and vars get confused)
  set statusline=%<%f\ \ %{StatusLineFileAttr()}\ \ %h%m%r\ %=\ buf#%n\ \ %-14.(L%l/%L:C%c%V%)\ %P
endif

" }}}
" [ runtimepath ] {{{

" make it easier to inspect rtp
command! ShowRunTimePath echo substitute(&rtp, ',', "\n", 'g')

" keep ~/.vim ahead of bundles in the list
command! -bar FixRunTimePath set rtp -=$HOME/.vim rtp ^=$HOME/.vim

" }}}
command! -nargs=+ MapCommand call MapCommand(<f-args>)
function MapCommand(key, cmd)
  exe "nnoremap <Leader>;" . a:key . " :" . a:cmd . "<CR>"
endfunction

MapCommand m make
" [ plugins ] {{{

" [ projectionist ] {{{

" Setup the global var once so that any other files can just call extend().
if !exists("g:projectionist_heuristics")
  let g:projectionist_heuristics = {}
endif
" The rest is done in plugin/projectionist.vim

" }}}

" [filetype] {{{
if !exists("*plug#begin")
  filetype off " turn off to load plugins (we turn it on later)
endif
" }}}

call plug#begin('~/.vim/plugged')


" [ dispatch ] {{{
" `:Make` => tmux split-window of :compiler into quickfix
" `:Make!` => background, no auto :copen
" `:Dispatch cmd ...` uses &compiler for cmd or just capture output
" `:Focus cmd ...` to set defaults for `:Dispatch` (also b:dispatch)
" `:Focus!` resets default
" `:Start ...` tmux new-window ...
" `:Start! ...` tmux new-window -d ...
Plug 'tpope/vim-dispatch', { 'on': ['Dispatch', 'Focus', 'Make', 'Start'] }
MapCommand d Dispatch
MapCommand s Start
" radenling/vim-dispatch-neovim
" }}}

" more powerful % matching?
"runtime macros/matchit.vim

" TODO: consider these:
" https://github.com/zaiste/vimified
" https://github.com/mutewinter/dot_vim
" vimscripts: 'L9' + 'FuzzyFinder'

Plug 'ervandew/supertab'
" TODO: supertab config

" [multiple cursors] {{{
" Setup additional characters for the plugin to recognize.
" The last line is the default list.
let g:multi_cursor_normal_maps = {'~':1,
  \ '!':1, '@':1, '=':1, 'q':1, 'r':1, 't':1, 'T':1, 'y':1, '[':1, ']':1, '\':1, 'd':1, 'f':1, 'F':1, 'g':1, '"':1, 'z':1, 'c':1, 'm':1, '<':1, '>':1}
let g:multi_cursor_visual_maps = {'~':1,
  \ 'i':1, 'a':1, 'f':1, 'F':1, 't':1, 'T':1}
Plug 'terryma/vim-multiple-cursors'
" }}}

" cursor jump selection with \mw or \mf
let g:EasyMotion_leader_key = '<leader>m'
Plug 'Lokaltog/vim-easymotion'

" custom text objects {{{

" better than just T/vt/ because it works across lines
" <start>i<char> to operate on text between pairs (`di/`)
let g:Textobj_defs = [
  \['/',     'Textobj_paired', '/'],
  \['!',     'Textobj_paired', '!'],
  \['<Bar>', 'Textobj_paired', '<Bar>'],
\]
Plug 'doy/vim-textobj'

" }}}
" [ yankring ] save a list of previously yanked text {{{

let g:yankring_history_dir = s:cache
let g:yankring_manage_numbered_reg = 0
" I usually have an x-based clipboard manager.
let g:yankring_clipboard_monitor = 0

" my terminal sends Esc when I press Alt
let g:yankring_replace_n_pkey = '<Esc>,'
let g:yankring_replace_n_nkey = '<Esc>.'

function! YRRunAfterMaps()
  " make Y yank to the end of the line like D
  nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
  " yr overrides 'p' on a visual selection but it pastes what was selected rather
  " than the previous item in the ring.  the original behavior works as i expect.
  xunmap p
endfunction

Plug 'vim-scripts/YankRing.vim'
nnoremap <silent> yr :YRShow<CR>
" switching windows loses the visual selection; this is what i mean:
xnoremap <silent> YR d:YRShow<CR>
" TODO: map something to :YRToggle ?

" }}}
" [ gundo ] visual undo browser {{{

" ubu 12.04 includes py2.7 which causes this thing to spew errors
let g:gundo_prefer_python3 = 1

Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
nnoremap <F12> :GundoToggle<CR>

" }}}
" [ file browser ] {{{
" [ nerdtree ] {{{

let g:NERDTreeCasadeOpenSingleChildDir  = 1
let g:NERDChristmasTree                 = 1
let g:NERDTreeHighlightCursorline       = 1
let g:NERDTreeHijackNetrw     = 1
let g:NERDTreeShowHidden      = 1
let g:NERDTreeShowLineNumbers = 1
let g:NERDTreeBookmarksFile   = s:cache . '/.NERDTreeBookmarks'
let g:NERDTreeIgnore = [
  \ '\~$',
  \ '^\..\+\.swp',
  \ '\.py[co]',
  \ '__pycache__',
  \ ]

Plug 'scrooloose/nerdtree', { 'on': ['NERDTree', 'NERDTreeToggle'] }

if g:NERDTreeHijackNetrw
  " tell netrw to forget it
  let g:loaded_netrwPlugin = "nerdtree!"
  " fake netrw's augroup so nerdtree will replace it
  augroup FileExplorer
    au!
    au BufEnter,VimEnter * if isdirectory(expand("<amatch>")) | unlet g:loaded_netrwPlugin | exe "NERDTree " . escape(expand("<amatch>"), ' \') | wincmd p | wincmd q | exe 'au! FileExplorer' | endif
  augroup END
endif

"function StartUp() | if 0 == argc() | NERDTree | end | endfunction
"autocmd VimEnter * call StartUp()

" }}}
" }}}
" [ git ] {{{

" get the latest fixes for vim files
Plug 'tpope/vim-git'
" powerful git integration
Plug 'tpope/vim-fugitive'
" gitk inside vim (http://www.gregsexton.org/portfolio/gitv/)
Plug 'gregsexton/gitv', { 'on': 'Gitv' }
" Diff signs in the gutter.
"Plug 'airblade/vim-gitgutter'

" }}}

" :grep
let &grepprg = "rg -H --no-heading --vimgrep $* \\| perl -e 'sub _ { $_[0] =~ s/\e\[[0-9;]+[a-z]//gr } print map { join(q[:], @$_) } sort { $a->[0] cmp $b->[0] \\|\\| _($a->[1]) <=> _($b->[1]) } map { [split /:/] } <>'"
" Add :Grepper for async
" let g:grepper.tools = ['rg', 'git', 'grep']
" Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }

" [ filetypes ] {{{

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
Plug 'fatih/vim-go', { 'for': ['go', 'gohtmltmpl', 'gomarkdown'] } " v1.15

Plug 'vim-scripts/bats.vim', { 'for': 'bats' }

"let g:csv_hiGroup = 'CSVHiColumn'
" let g:csv_highlight_column = 'y'
Plug 'chrisbra/csv.vim', { 'on': 'CSVMode' }
" More often than not I just want to peek at the file without all the magic.
"command! CSV setf ft=csv | doautocmd FileType csv
Plug 'mechatroner/rainbow_csv' " does not contain ftdetect

" less css
Plug 'groenewege/vim-less', { 'for': ['less', 'html'] }

" coffee script
Plug 'kchmck/vim-coffee-script', { 'for': ['coffee', 'html', 'eco'] }
Plug 'AndrewRadev/vim-eco', { 'for': 'eco' }

" elm
Plug 'lambdatoast/elm.vim', { 'for': 'elm' }

" purescript
Plug 'raichoo/purescript-vim', { 'for': 'purescript' }

" redmine uses textile
"Plug 'timcharper/textile.vim', { 'for': 'textile' }

" FIXME: This doesn't work with any syntaxes that are lazily added to &rtp.
" But it would if we generated a tree with all the files linked into it.
"let g:markdown_fenced_languages = [ 'bash', 'perl', 'ruby', 'sh' ]
Plug 'tpope/vim-markdown', { 'for': 'markdown' }

" [ python ] {{{
" python template engine
Plug 'sophacles/vim-bundle-mako', { 'for': 'mako' }
Plug 'Glench/Vim-Jinja2-Syntax'

" compiler (makeprg) for nosetests
" NOTE: pip install git+git://github.com/nvie/nose-machineout.git#egg=nose_machineout
Plug 'lambdalisue/nose.vim', { 'for': 'python' }
" }}}

" [ ruby ] {{{
Plug 'vim-ruby/vim-ruby', { 'for': ['ruby', 'eruby'] }
Plug 'tpope/vim-rails', { 'for': ['ruby'] }

" let g:rufo_auto_formatting = 1
" Plug 'ruby-formatter/rufo-vim'
" }}}

" [ clojure ] {{{
"let g:rbpt_loadcmd_toggle = 1
Plug 'kien/rainbow_parentheses.vim' ", { 'for': 'clojure' }

"Plug 'vim-scripts/VimClojure'
"https://github.com/clojure-vim
"https://github.com/clojure-vim/clj-refactor.nvim
"https://github.com/clojure-lsp/clojure-lsp

let g:clojure_syntax_keywords = {
    \ 'clojureDefine': ["defproject", "deftask", "deftesttask"],
    \ }
" let g:clojure_special_indent_words = 'boot/with-pass-thru'
let g:clojure_fuzzy_indent = 1
" For things like (boot/with- it only looks at "boot", so go with it.
let g:clojure_fuzzy_indent_patterns = [
  \ '^with', '^def', '^let',
  \ '^boot$',
  \ ]
Plug 'clojure-vim/clojure.vim', { 'for': 'clojure' }
" Plug 'guns/vim-clojure-static', { 'for': 'clojure' }

Plug 'guns/vim-sexp', { 'for': ['clojure', 'joker'] }

" let g:iced_enable_default_key_mappings = v:true
" Plug 'liquidz/vim-iced', { 'for': 'clojure' }
if s:nvim
  Plug 'Olical/conjure', { 'for': 'clojure' }
  autocmd FileType clojure command! ShadowCljs exe ":ConjureShadowSelect dev" | exe ":ConjureEval (add-tap prn)" | exe ":norm \\ls" | exe ":set wrap" | exe ":norm! <c-w><c-w>"
  vmap \ev \E
  "Plug 'tami5/lispdocs.nvim' " already a filetype plugin
else
  Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
  " Use cljstyle instead.
  autocmd User FireplaceActivate setl formatexpr=
endif

if !filereadable(".no-cljfmt")
  Plug 'venantius/vim-cljfmt', { 'for': 'clojure' }
  command DisableCljFmt exe "aug vim-cljfmt | au! | aug END"
endif

" Plug 'rwstauner/vim-clojure-auto-repl', { 'for': 'clojure' }

"Plug 'fbeline/kibit-vim', { 'on': 'Kibit' }

" Plug 'tpope/vim-salve'
" Plug 'tpope/vim-classpath', { 'for': 'clojure' }

com! ParEditToggle let g:paredit_mode = abs(g:paredit_mode - 1)
let g:paredit_leader = ','
Plug 'kovisoft/paredit', { 'for': ['clojure', 'joker'] }

" json: better than 'javascript'
Plug 'elzr/vim-json', { 'for': 'json' }

" [ javascript ] {{{
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }

let g:jsx_ext_required = 0 " Allow JSX in normal JS files
Plug 'mxw/vim-jsx', { 'for': 'javascript' }
" }}}

" xml shortcuts
let xml_use_xhtml = 1
Plug 'sukima/xmledit', { 'for': 'xml' }
"command! XMLMode exe "LazyBundle 'sukima/xmledit'" | set ft=xml
"command! XMLMode set ft=xml

" Plug 'ingydotnet/yaml-vim', { 'as': 'yaml-ingy' }
" Plug 'mrk21/yaml-vim', { 'as': 'yaml-mrk21' }
" Plug 'hhys/yaml-vim', { 'as': 'yaml-hhys' }
" Plug 'lucdew/vim-yaml', { 'as': 'yaml-lucdew' }
" Plug 'chase/vim-ansible-yaml'

" }}}
" [ ale ] Asynchronous Lint Engine {{{

let g:ale_lint_on_enter        = 0 " The linter runs constantly if this is on.
let g:ale_lint_on_save         = 1
let g:ale_lint_on_text_changed = 0
"let g:ale_lint_delay           = 200 " millisecond delay before checking
"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_statusline_format = ['✖ %d', '⚠ %d', '\o/']
" let g:ale_sign_column_always = 1

let g:ale_linters = {
  \   'clojure': ['clj-kondo'],
  \   'ruby': ['rubocop'],
  \ }


nmap <silent> [w <Plug>(ale_previous_wrap)
nmap <silent> ]w <Plug>(ale_next_wrap)

" augroup PostALE
"     autocmd!
"     autocmd User ALELint call YourFunction()
" augroup END

set statusline+=%#warningmsg#
set statusline+=%{ale#statusline#Status()}
"set statusline+=%{ALEGetStatusLine()}
set statusline+=%*

Plug 'w0rp/ale'

" }}}

" :TestSuite, :TestFile, :TestNearest
" let test#strategy = "dispatch" " use quickfix
Plug 'janko/vim-test'

" [ slime ] pass vim text to a repl via terminal multiplexer {{{

if $MULTIPLEXER != ""
  " do we want to autoload via the mappings?
  "nmap <C-c><C-c> :SlimeREPL<CR>

  Plug 'jpalardy/vim-slime', { 'on': 'SlimeREPL' }
  command SlimeREPL call SlimeREPL()
  function SlimeREPL()
    " configure and load plugin
    if !exists("g:slime_paste_file")
      let g:slime_target = $MULTIPLEXER
      let g:slime_paste_file = tempname() | " my tmux has issues with pipes
    endif

    if $MULTIPLEXER == "tmux"
      " split to put repl below
      call system("tmux split-window -v")
      " move focus back to original
      call system("tmux select-pane -t :.-1")
    endif

    " slime mappings should be installed
    "normal <C-c><C-c>
  endfunction
endif

" }}}

call plug#end()

" Fix up things that need to be done after the plugins are loaded.

FixRunTimePath
" }}}

" [ misc ]

"for TOhtml
let use_xhtml = 1
let html_use_css = 1
let html_no_pre = 1

" highlight conflict markers
au BufReadPost * call matchadd("ErrorMsg", '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$')
" highlight todo messages in any syntax (but not "doToDonut")
au BufReadPost * call matchadd("ToDo", '\c[a-z]\@<!\v(TODO|FIXME|NOTE|XXX|HACK|TBD|EXPERIMENTAL|BODGE)')

colorscheme wounded

" [filetype / syntax] {{{
" Do filetype then syntax in case the ftplugin customizes the syntax defs.
" vim-plug does this so we don't need to do it again.
if !exists("*plug#end")
  filetype plugin indent on
  syntax enable
endif
" }}}
" Do this late to avoid being overwritten.
au FileType clojure,joker exe "RainbowParenthesesLoadRound" | RainbowParenthesesActivate

" Show me EN SPACE characters when I copy text from hipchat.
match Error /\%u2002/


" restore previous cursor position (:help last-position-jump)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" open the fold if the initial position is inside one
au BufWinEnter * if !exists("b:did_zv") | exe "normal zv" | let b:did_zv = 1 | endif

" open (or close) the quickfix window after make/grep commands
autocmd  QuickFixCmdPost *make*,*grep* cwindow

" Turn an open buffer into a quickfix list (for pasting the output of a command into a buffer).
command! -bang QuickFixThis let &l:modified = !strlen("<bang>") | cbuffer | copen | cfirst

" try hard to highlight correctly
"autocmd BufEnter,CursorHold,CursorHoldI * syntax sync fromstart

"let s:do_lwindow = 0
"autocmd  QuickFixCmdPost *lmake*,*lgrep* let s:do_lwindow = 1
"autocmd  BufWinEnter * if s:do_lwindow | lwindow | let s:do_lwindow = 0 | endif

"autocmd  BufWinEnter * if !empty(getloclist(0)) | lwindow | endif

" Don't leave the location list open after i quit the buffer.
" But don't if the window being quit is the quickfix or it will segfault.
autocmd QuitPre * if &buftype != 'quickfix' | lclose | endif

" simulate readline in command mode {{{

cnoremap <C-A> <Home>
"cnoremap <C-E> <End> " default
" make alt-D delete the next word by moving over and then deleting back
cnoremap <A-D> <C-Right><C-W>
" my terminal makes it an escape
cmap d <A-D>

" }}}
" [ commands ] {{{

" needs to be ft specific... or can we use 'commentstring' ?
" command! CopyOneLine :w ! tr '\n' ' ' | clip

" Useful for any function that takes args (expands after pressing space).
function! SetupCommandAlias(input, output)
  exec 'cabbrev <expr> '.a:input
    \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:input.'")'
    \ .'? ("'.a:output.'") : ("'.a:input.'"))'
endfunction
" stupid fingers (either too fast or too slow...)
call SetupCommandAlias("W", "w")
call SetupCommandAlias("Grep", "grep")
command -bang Q q<bang>
command -bang Qall qall<bang>
command Wq wq
command WQ wq
command Wn wn
command WN wN
command Args args
call SetupCommandAlias("Sp", "sp")

command! Mkpath call mkdir(expand("%:h"), 'p')

command EightyCharacters call MaxLineLength(80)
command -nargs=? MaxLineLength call MaxLineLength(<f-args>)

command! ModeLine exe "norm O" . substitute(&cms, ' \?%s', " vim: set ts=2 sts=2 sw=2 expandtab smarttab:", '')

command! -range GitUrl exe "! git url '" . expand("%") . "' " . <line1> . " " . <line2> . " | clip"
command! GitCleanupCommitMsg :%! perl -pe 'exit 0 if /^\#/'
command! GitCommitMsgHook exe "GitCleanupCommitMsg" | Git maybe commit-msg-hook %

" using named register ("p) is easier than escaping expr reg ("=)
"command! -nargs=1 -bang -complete=expression Put let @p = <args> | put<bang> p
command! -nargs=1 -bang -complete=expression Put call append(line(".") - ('<bang>' == '!' ? 1 : 0), <args>)

call SetupCommandAlias("Set", "set")
call SetupCommandAlias("Echo", "echo")
command -nargs=1 -complete=file 	Rename 	call RenameCurrent(<q-args>)
command -nargs=+ -range 			CommentSection call CommentSection(<f-args>)

command -nargs=1 FoldComments	call FoldComments(<f-args>)
command! -nargs=1 TabWidth exe "setlocal ts=" . <args> . " sts=" . <args> . " sw=" . <args>

if exists("+cursorline")
  command HighlightPosition set cursorcolumn! cursorline!
endif

command -nargs=1 -complete=dir -complete=file Arge 99arge <args>

command SynStack for id in synstack(line("."), col(".")) | echo synIDattr(id, "name") . " => " . synIDattr(synIDtrans(id), "name") | endfor

command -range=% TabbedToAsciiTable <line1>,<line2>! perl -MText::ASCIITable -e '$t = Text::ASCIITable->new({hide_FirstLine => 1, hide_LastLine => 1}); $t->setCols(split(/\t/, scalar <STDIN>)); $t->addRow(split(/\t/)) for <STDIN>; $line = [qw(| | - |)]; $row = [qw(| | |)]; print $t->draw($line, $row, $line, $row, $line);'

if s:nvim
  for prefix in ['', 'v']
    exe 'command -nargs=* '.toupper(prefix).'Term exe "'.prefix.'new | terminal " . <q-args>'
  endfor
  au TermOpen * setlocal foldcolumn=0
endif
" }}}

" [ mappings ] {{{
" <Leader> == 'mapleader' (default: "\") (other good choices: [, ])
let mapleader = '\'
" TODO: mapping for :tabedit ?

" Create shortcuts for common % modifier operations.
function ExpandEscaped(exp)
  " We need to double-escape for the backslashes to make it to the command line.
  return substitute(expand(a:exp), " ", "\\\\ ", "g")
endfunction
" full path
cnoremap %p <C-R>=ExpandEscaped('%:p')<CR>
" head (parent dir)
cnoremap %h <C-R>=ExpandEscaped('%:h').'/'<CR>
" tail (file)
cnoremap %t <C-R>=ExpandEscaped('%:t')<CR>
" root (extention removed)
cnoremap %r <C-R>=ExpandEscaped('%:r')<CR>

" suggested by motion.txt for jumping to braces (not in the first column)
map <silent> [[ ?{<CR>:noh<CR>w99[{
map <silent> ][ /}<CR>:noh<CR>b99]}
map <silent> ]] j0[[%/{<CR>:noh<CR>
map <silent> [] k$][%?}<CR>:noh<CR>

" Let me use y} to yank the end of the paragraph but include the whole line.
onoremap } V}

" thanks to sartak for these (https://github.com/sartak/conf/blob/master/vimrc): {{{

" Hit <C-a> in insert mode after a bad paste (thanks absolon) {{{
inoremap <silent> <C-a> <ESC>u:set paste<CR>.:set nopaste<CR>gi
" }}}

" up and down move by virtual line
nmap <Up>   gk
nmap <Down> gj
" keep visual selection on in/out-dent
xnoremap < <gv
xnoremap > >gv

" Swap ` (preserves which column the cursor was in) and ' (which does not)
nnoremap ' `
nnoremap ` '

" }}}
" borrow ideas from sartak, modify slightly {{{

" ctrl-space to insert a single character before the cursor
nnoremap <C-@> i <Esc>:echo "put character:"<CR>r

" center screen and auto-open folds when searching
if 0 " i like the idea but in practice it's too jumpy for me
  nmap n   nzzzv
  nmap N   Nzzzv
  nmap *   *zzzv
  nmap #   #zzzv
  nmap g* g*zzzv
  nmap g# g#zzzv
endif

" }}}

" TODO: consider swapping '*' and 'g*' (and '#' and 'g#')

" thanks to doy for these (https://github.com/doy/conf/blob/master/vimrc): {{{
" F5 to :make {{{
map  <F5> :make<CR><CR><C-W>k
imap <F5> <C-O>:make<CR><CR><C-O><C-W>k
" }}}
" Painless spell checking {{{
function! s:spell()
  if !&spell
    echo "Spell check on"
    setlocal spell
    " TODO: what do we want here?
    "if &spelllang != "en_us"
      " TODO: add more, maybe even Pod::Wordlist::hanekomu
      "set spelllang=en_us
    "endif
  else
    echo "Spell check off"
    setlocal nospell
  endif
endfunction
command SpellToggle call <SID>spell()
map <F9> :SpellToggle<CR>
imap <F9> <C-o>:SpellToggle<CR>
" }}}
" }}}

nmap <C-l> <C-l>:nohl<CR>:syntax sync fromstart<CR>

" re-highlight last search without moving cursor
nmap <Leader>/h :set hlsearch<CR>
" unhighlight last search
nmap <Leader>/n   :nohlsearch<CR>

" retab (remove the tabs from) the current line
nnoremap <Leader><Tab> :.retab<CR>
vnoremap <Leader><Tab> :retab<CR>gv

" maximize current window
nmap <C-w>* <C-w>_<C-w>\|

"goto file by adding it to the argument list
nmap <Leader>gf gf:$arge %<CR>
nmap <Leader>F 			:99arge <cfile><CR>

nmap <Leader>J			gJkgJ
"CamelCase -> underscore
nmap <silent> <Leader>_ 	i_gu2l
vmap <silent> <Leader>_ 	<Esc>:set lz<CR>`>a`<i:s/\v([a-z])([A-Z])/\1_\l\2/g<CR>gJkgJ:set nolz<CR>:redraw<CR>:silent noh<CR>

" html paragraph
nmap <silent> <Leader>hp 	:norm {o<p>}O</p>
nmap <silent> <Leader>hP 	:norm o</p>oo<p>
" html div
nmap <silent> <Leader>hd 	:norm {o<div>}O</div>
nmap <silent> <Leader>hD 	:norm o</div>oo<div>
"html tags
nmap <silent> <Leader>he 	:call HtmlEscape(    )<CR>
nmap <Leader>hr 		i<lt>br /><Esc>
nmap <Leader>hR 		A<lt>br /><Esc>
nmap <Leader>hh 		i<lt>hr /><Esc>
nmap <Leader>hH 		A<lt>hr /><Esc>
nmap <Leader>h! 		A --><Esc>I<!-- <Esc>l

" TODO: fix these to use text objects
"upper and lower case current word or selection
nmap <Leader>cu wgUbe
nmap <Leader>cl wgube
nmap <Leader>cU WgUBE
nmap <Leader>cL WguBE
vmap <Leader>cu <Esc>`>gUlgU`<
vmap <Leader>cl <Esc>`>gulgu`<

" search buffer for the current selection ('as is')
vmap <Leader>/ yq/p0i\V
" :grep for the current selection
vmap <Leader>g yq:igrep <Esc>p

" Ovid: show first commit where term under cursor was added
" http://twitter.com/OvidPerl/status/28395223746875392
nmap <leader>1 :!git log --reverse -p -S<cword> %<cr>
" Ovid: handy if hacking urls
" http://twitter.com/OvidPerl/status/28076709865586688
vnoremap <leader>un :!perl -MURI::Escape -e 'print URI::Escape::uri_unescape(do { local $/; <STDIN> })'<cr>

if s:nvim
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-v><Esc> <Esc>
endif

" }}}

" [ functions ] {{{

function CleanupWordPaste() range
"	'<,'>s/–/.../g
	'<,'>s/–/--/g
	'<,'>s/’/'/g
	'<,'>s/[“”]/"/g
endfunction

" wrap visual selection in a commented [section] block
function CommentSection(section) range
  let section = "[ " . a:section . " ]"
  exe "norm '>o" . printf(&commentstring, " } " . section)
  exe "norm '<O" . printf(&commentstring, " "   . section . " {")
endfunction

function! MaxLineLength(...)
  " default 80 characters
  call matchadd('ErrorMsg', '\%>' . (a:0 >= 1 ? a:1 : 80) . 'v.\+')
endfunction

function FoldComments(singleline) "Create folds of consecutive commented lines by sending singleline comment starter
	set foldmethod=expr
	execute "set foldexpr=getline(v:lnum)=~\\\"^" . a:singleline . "\\\""
endfunction

" highlight arbitrary matches in the file with a different color each time
" TODO: consider 'inkarkat/vim-mark'
command -nargs=+  Highlight  call Highlight(<q-args>)
let s:dynamicHighlight=0
function Highlight(hl)
  let s:dynamicHighlight = s:dynamicHighlight + 1
  let l:dhlmatch = "dynamicHighlight" . s:dynamicHighlight
  let l:hl = (&ignorecase ? "\\c" : "") . a:hl
  exe "highlight " . l:dhlmatch . " cterm=bold,underline ctermbg=black ctermfg=" . s:dynamicHighlight
  call matchadd(l:dhlmatch, l:hl)
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

function LoadSyntax(...)
	let l:syn = a:0 > 0 ? a:1 : "tt2"
	let l:bcs = b:current_syntax
	unlet b:current_syntax
	exe "runtime! syntax/" . l:syn . ".vim"
	let b:current_syntax = l:bcs
endfunction

function RenameCurrent(name)
	let name = a:name
	if match(name, "/") == -1
		let name = expand("%:h") . "/" . name
	end
	call rename(expand("%"), name)
	exe "edit " . name
endfunction

" The builtin uniq() expects sorted lists.
function! UniqAll(list)
  let l:seen = {}
  let l:new = []
  for l:item in a:list
    if !has_key(l:seen, l:item)
      call add(l:new, l:item)
      let l:seen[l:item] = 1
    endif
  endfor
  return l:new
endfunction
" }}}

" Remove duplicate entries that end up in path.
" NOTE: This will remove the "current dir" element of `,,`.
"let &path = join(UniqAll(split(&path, ',', 1)), ',')

" [ see also ] {{{
" http://vim.wikia.com/wiki/Vim_Tips_Wiki
" https://github.com/derekwyatt/vim-config
" https://github.com/paradigm/dotfiles/blob/master/.vimrc#L215
" https://github.com/sunaku/vim-unbundle
" https://github.com/sartak/conf/blob/master/vimrc (nopaste)
" https://github.com/doy/conf/blob/master/vimrc
" https://github.com/nelstrom/dotfiles/tree/master/vim/bundle
" http://www.vim.org/scripts/script_search_results.php?order_by=downloads
" https://launchpad.net/ubuntu/+source/vim-scripts/+changelog
" https://github.com/sjl/dotfiles/tree/master/vim/vimrc
" https://github.com/kien/ctrlp.vim
" }}}

let local_vimrc = expand("$HOME/.vim/local.vim")
if filereadable(local_vimrc)
  exe "source " . local_vimrc
endif
unlet local_vimrc

" :Ni!
set secure " last
set noexrc
