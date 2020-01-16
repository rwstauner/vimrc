" vim: set ts=2 sts=2 sw=2 expandtab smarttab fdm=marker:
"this file works with unix.  you should too.
"
" TODO: learn more about tabs, tags, quickfix, loc list, plugins...

set nocompatible   " set this first as it can change other things

if version < 700
  echoerr "this vimrc requires vim 7"
endif

if filereadable(expand("$HOME/.vim/macros/local_before.vim"))
  runtime macros/local_before.vim
endif

let s:cache = expand("$HOME/.cache/vim-cache")

" [ encoding ] {{{

set     encoding=utf-8
set termencoding=utf-8

" this should be the default (with LANG=en_US.utf-8)
setglobal fileencodings=ucs-bom,utf-8,default,latin1

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
set   directory=~/.cache/vim-tmp// " Put swapfiles here (// for full path) so that they aren't in project dirs.
set nofileignorecase " DWIM (pretend mac is case sensitive to limit undesired results)
set   foldcolumn=2 " width
set   foldopen +=insert,jump " auto-open folds when inserting or jumping far
set noequalalways  " don't resize windows when i split, just split
set   esckeys      " allow arrow keys to work in insert mode (adjust timeoutlen if necessary)
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
set nomore         " don't give more-style prompts, i use tmux
set   nrformats=octal,hex,alpha
set   number       " show line numbers
"set   path+=./**   " search for files anywhere below current file's parent dir
set   report=0     " show number of lines changed by a command
set   scrolloff=2  " show lines of context around cursor at top or bottom of screen
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
set noexpandtab nosmarttab " off by default, enabled by filetype plugins
set ignorecase smartcase " searching for lowercase is case-insensitive (use \c \C to override)
set noshowmatch matchtime=1 " on insert highlight matching bracket for 0.x seconds

let &shell="env PATH=" . expand('$PATH') . ' ' . &shell

" TODO: investigate 'cpoptions'

" }}}

" Don't load other language syntax files when editing vim files.
let g:vimsyn_embed = 0 "  'pP' => p: perl, P: python

" [ undo ] {{{

" remember :display and redo-register

" :help undo-persistence
if exists("+undofile")
  set undofile
  set undodir=~/.cache/vim-undo " dir must already exist
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

function! StatusLineFileAttr()
  return "(ft=" . &filetype . " fenc=" . &fileencoding . (&fileformat != "unix" ? " ff=" . &fileformat : "") . ")"
endfunction
" don't want stl=%!func() b/c it re-evaluates with each C-W (and vars get confused)
set statusline=%<%f\ \ %{StatusLineFileAttr()}\ \ %h%m%r\ %=\ buf#%n\ \ %-14.(%l/%L,%c%V%)\ %P

" }}}
" [ runtimepath ] {{{

" make it easier to inspect rtp
command! ShowRunTimePath echo substitute(&rtp, ',', "\n", 'g')

" keep ~/.vim ahead of bundles in the list
command! -bar FixRunTimePath set rtp -=$HOME/.vim rtp ^=$HOME/.vim

" dump misc. downloaded files in here instead of $HOME/.vim
set rtp ^=$HOME/.vim/unbundled rtp +=$HOME/.vim/unbundled/after

" }}}
command! -nargs=+ MapCommand call MapCommand(<f-args>)
function MapCommand(key, cmd)
  exe "nnoremap <Leader>;" . a:key . " :" . a:cmd . "<CR>"
endfunction

MapCommand m make
" [ plugins ] {{{

" [filetype] {{{
if !exists("*plug#begin")
  filetype off " turn off to load plugins (we turn it on later)
endif
" }}}

call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align', { 'on': ['EasyAlign', '<Plug>(EasyAlign)'] }
" ga<motion><num><char>
nmap ga <Plug>(EasyAlign)

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
" }}}

" [ projectionist ] {{{
" Read .projections.json for file type metadata.
Plug 'tpope/vim-projectionist'
" }}}

" more powerful % matching?
"runtime macros/matchit.vim

" editorconfig {{{
Plug 'editorconfig/editorconfig-vim'
" Overwrite filetype.
autocmd BufWinEnter .editorconfig set filetype=cfg
" }}}

Plug 'keith/tmux.vim'

" Disable the tmux escape sequence wrapper as it seems unnecessary in my usual env.
let g:bracketed_paste_tmux_wrap = 0
Plug 'ConradIrwin/vim-bracketed-paste'

" [ vim-tmux-navigatior ] {{{
let g:tmux_navigator_no_mappings = 1
" let g:tmux_navigator_save_on_switch = 0

Plug 'christoomey/vim-tmux-navigator'

" S-Left S-Down S-Up S-Right
noremap <silent> [1;2A   :<C-U>TmuxNavigateUp<cr>
noremap <silent> [1;2B   :<C-U>TmuxNavigateDown<cr>
noremap <silent> [1;2C   :<C-U>TmuxNavigateRight<cr>
noremap <silent> [1;2D   :<C-U>TmuxNavigateLeft<cr>
" This one doesn't fit :/
noremap <silent> <C-\>     :<C-U>TmuxNavigatePrevious<cr>

" Note: In visual mode the selection won't be preserved
" but this is also the case for regular C-w commands, so that's fine.
" }}}

" Reopen all "file:line" args as file at line.
" This seems to conflict with NERDTree (on the first arg).
let g:file_line_bundle_cmd = "Plug 'bogado/file-line'"
" Load it automatically if any args contain a colon.
if match(argv(), ':') >= 0 | exe g:file_line_bundle_cmd | endif
" Can also be delayed behind a command (add dir to rtp, load plugin, and
" trigger autocommand that the plugin listens for (no api is exposed)).
"command! FileLine exe g:file_line_bundle_cmd | runtime plugin/file_line.vim | silent doautocmd <nomodeline> VimEnter *

" TODO: consider these:
" https://github.com/zaiste/vimified
" https://github.com/mutewinter/dot_vim
" vimscripts: 'L9' + 'FuzzyFinder'

" [fzf] {{{
let g:fzf_buffers_jump = 1
" The '' key is for "enter".
let g:fzf_action = { '': 'split', 'ctrl-t': 'tab split', 'ctrl-x': 'edit',  'ctrl-v': 'vsplit' }
let g:fzf_command_prefix = 'FZF'

"set rtp+=~/homebrew/opt/fzf
"Plug '~/homebrew/opt/fxf'
Plug 'junegunn/fzf', { 'dir': '~/usr/fzf', 'do': './install --key-bindings --completion < /dev/null' }
Plug 'junegunn/fzf.vim'

nnoremap <Leader><Tab> :FZF<CR>
nnoremap <C-t> :FZF<CR>
nmap <leader><C-f> <plug>(fzf-maps-n)
xmap <leader><C-f> <plug>(fzf-maps-x)
omap <leader><C-f> <plug>(fzf-maps-o)
cmap <C-F> <C-U>FZF<CR>
" }}}

Plug 'ervandew/supertab'
" TODO: supertab config

" i tried delimitmate but it gets in my way more often than it's useful
"Plug 'Raimondi/delimitMate'

" enable repeating certain plugin actions with .
Plug 'tpope/vim-repeat'

" view images
" TODO: try this, then lazy-load it
"Plug 'tpope/vim-afterimage'

" toggle comment state with gc<motion>
Plug 'tpope/vim-commentary'
" navigate various things back and forth with [x and ]x (t,l,q...)
Plug 'tpope/vim-unimpaired'
" better management of quotes and paired symbols than i used to do
Plug 'tpope/vim-surround'
" Don't make me reach for `y`.
nmap S ys

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
let g:EasyMotion_leader_key = 'm'
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

Plug 'YankRing.vim'
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
" [ netrw ] (built-in) {{{

let g:netrw_home         = s:cache
let g:netrw_liststyle    = 3  " Use tree-mode as default view
let g:netrw_browse_split = 2  " vsplit
let g:netrw_preview      = 1  " preview window shown in a vertical split
let g:netrw_winsize      = 20 " inital size of new browser

" }}}
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

" }}}
" [ perl ] {{{

" use ack as &grepprg
Plug 'mileszs/ack.vim', { 'on': 'Ack' }
Plug 'rking/ag.vim', { 'on': 'Ag' }

" syntax and ftplugin files for perl (plus pod, tt2...)
" include sql for tt2 queries
Plug 'vim-perl/vim-perl', { 'for': ['perl', 'pod', 'tt2', 'tt2html', 'sql'] }

" syntax files for CPAN::Changes
Plug 'rwstauner/vim-cpanchanges', { 'for': 'cpanchanges' }

" enable :Perldoc command (via Pod::Simple::Vim)
"let g:Perldoc_path = s:cache . '/perldoc/'
"Plug 'PERLDOC2'

" enable :Perldoc command (via perldoc command plus vim parsing)
"Plug 'Perldoc.vim'

" prove the current file and put colored results in a special window
"Plug 'motemen/tap-vim'

" enable :make to run prove and put test failures in the quickfix
Plug 'perlprove.vim', { 'for': 'perl' }
  au BufRead,BufNewFile *.t set filetype=perl | compiler perlprove

runtime macros/stub_perl_mod.vim

" https://github.com/yko/mojo.vim

" }}}
" [ filetypes ] {{{

"let g:csv_hiGroup = 'CSVHiColumn'
let g:csv_highlight_column = 'y'
Plug 'chrisbra/csv.vim', { 'for': 'csv' }
" More often than not I just want to peek at the file without all the magic.
"command! CSV setf ft=csv | doautocmd FileType csv

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
" FIXME: This seems to load the syntastic check for sh which fails miserably.
"let g:markdown_fenced_languages = [ 'bash', 'perl', 'ruby', 'sh' ]
"Plug 'tpope/vim-markdown', { 'for': 'markdown' }

" [ python ] {{{
" python template engine
Plug 'sophacles/vim-bundle-mako', { 'for': 'mako' }

" compiler (makeprg) for nosetests
" NOTE: pip install git+git://github.com/nvie/nose-machineout.git#egg=nose_machineout
Plug 'lambdalisue/nose.vim', { 'for': 'python' }
" }}}

" [ ruby ] {{{
Plug 'vim-ruby/vim-ruby', { 'for': ['ruby', 'eruby'] }
" }}}

" [ puppet ] {{{
" puppet: https://github.com/puppetlabs
" alternative: 'rodjek/vim-puppet'
Plug 'puppetlabs/puppet-syntax-vim', { 'for': 'puppet' }

" TODO: Put this somewhere else.
let s:puppet_lint_args = '--no-80chars-check --no-arrow_alignment-check'
command -nargs=* -complete=file PuppetLint call PuppetLint(<f-args>)
function PuppetLint(...)
  let l:makeprg = &makeprg
  let l:efm = &efm

  let &l:makeprg='find ' . (a:0 ? a:1 : '.') . ' -name \*.pp \| xargs --no-run-if-empty -n 1 puppet-lint ' . s:puppet_lint_args . ' --log-format "\%{path}:\%{linenumber}:\%{kind}:\%{check}:\%{message}"'
  setl efm=%f:%l:%t%*[a-z]:%m
  make

  let &efm = l:efm
  let &makeprg = l:makeprg
endfunction
" }}}

" go
if exists('$GOROOT') && isdirectory($GOROOT)
  source $GOROOT/misc/vim/ftdetect/gofiletype.vim
  au FileType go set rtp^=$GOROOT/misc/vim rtp+=$GOROOT/misc/vim/after | FixRunTimePath
endif

" [ scala ] {{{
" if exists('$SCALA_DIST') && isdirectory($SCALA_DIST)
"   source $SCALA_DIST/tool-support/src/vim/ftdetect/filetype.vim
"   " NOTE: Currently there's no 'after' directory.
"   au FileType scala set rtp^=$SCALA_DIST/tool-support/src/vim | FixRunTimePath
" endif
" See also: https://gist.github.com/schmmd/1320359.
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }
Plug 'derekwyatt/vim-sbt', { 'for': 'sbt.scala' }
" }}}

" [ clojure ] {{{
"let g:rbpt_loadcmd_toggle = 1
Plug 'kien/rainbow_parentheses.vim' ", { 'for': 'clojure' }

"Plug 'vim-scripts/VimClojure'
Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" tpope/vim-classpath
" guns/vim-clojure-static
com! ParEditToggle let g:paredit_mode = abs(g:paredit_mode - 1)
let g:paredit_leader = ','
Plug 'kovisoft/paredit', { 'for': 'clojure' }
" }}}

Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }

" json: better than 'javascript'
Plug 'elzr/vim-json', { 'for': 'json' }

" [ javascript ] {{{
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }

let g:jsx_ext_required = 0 " Allow JSX in normal JS files
Plug 'mxw/vim-jsx', { 'for': 'javascript' }

Plug 'tmcw/vim-eslint-compiler', { 'for': 'javascript' }
" }}}

" fishshell.com
"Plug 'aliva/vim-fish', { 'on': 'fish' }

" haxe: see http://haxe.org/com/ide/vim
"Plug 'vim-haxe' " requires vim-addon-manager
"Plug 'jdonaldson/vaxe'
" wikidoc: Plug 'wikidoc.vim'

" TODO: https://github.com/janko-m/vim-test

" xml shortcuts
let xml_use_xhtml = 1
Plug 'sukima/xmledit', { 'for': 'xml' }
"command! XMLMode exe "LazyBundle 'sukima/xmledit'" | set ft=xml
"command! XMLMode set ft=xml

" }}}
" [ syntastic ] automatic syntax check into location list {{{

let g:syntastic_check_on_open=0 " avoid start-up delay; check on save, not open
let g:syntastic_check_on_wq = 0 " If I issue :wq just let me leave.
let g:syntastic_aggregate_errors = 1
let g:syntastic_auto_jump=0
let g:syntastic_auto_loc_list=1
let g:syntastic_enable_balloons = 0
"let g:syntastic_ignore_files = ['^/usr/include/', '\c\.h$']
let g:syntastic_loc_list_height=5
"let g:syntastic_mode_map = { 'mode': 'active', \ 'active_filetypes': ['ruby', 'php'], \ 'passive_filetypes': ['puppet'] }
"g:syntastic_quiet_messages = {'level': 'warnings'}
let g:syntastic_stl_format='[Syntax: %E{Err: %fe #%e}%B{, }%W{Warn: %fw #%w}]'

let g:syntastic_javascript_checkers = ['eslint']
"let g:syntastic_javascript_eslint_exec = substitute(system("npm bin"), '\n$', '', '') . '/eslint'
let g:syntastic_javascript_eslint_exec = 'node_modules/.bin/eslint'

let g:syntastic_ruby_checkers = [ 'mri', 'rubocop' ]

let g:syntastic_python_checkers = [ 'pylint', 'python' ]
let g:syntastic_puppet_puppetlint_args = s:puppet_lint_args

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
Plug 'scrooloose/syntastic'

" }}}
" [ statline ] override statusline with something more powerful {{{

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
Plug 'millermedeiros/vim-statline'

" }}}
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
" [ covim ] {{{
"Plug 'FredKSchott/CoVim', { 'on': 'CoVim' }
" :CoVim start [port] [name]
" :CoVim connect host port name
" :CoVim disconnect
" }}}

call plug#end()

" Fix up things that need to be done after the plugins are loaded.

FixRunTimePath
" }}}

command SourceCodeStyle setlocal ts=2 sts=2 sw=2 expandtab smarttab

" [ tags ] {{{

"set tags+=~/.vim/tags/ptags " cpan: Vim::Tags
nmap <Leader>[t :sp +tN<CR>
nmap <Leader>]t :sp +tn<CR>

" I'd like a plugin that explores my whole tags file, but these only operate
" on the current buffer (which I haven't found useful yet)
"Bundle 'taglist.vim'
"Bundle 'majutsushi/tagbar'

" }}}
" [ misc ]

"for TOhtml
let use_xhtml = 1
let html_use_css = 1
let html_no_pre = 1

" [ term ] {{{

" fast terminal connection, smoother redrawing
set ttyfast

" fix ctrl-arrow to work in command line mode (:help term.txt)
" vim doesn't have t_XX codes for C-arrow but S-arrow performs the same function
set t_#4=[1;5D
set t_%i=[1;5C
" make ctrl-pg up/down cycle tabs like they're supposed to
"set t_K3=[5;5~
"set t_K5=[6;5~
"nmap <kPageUp>   gT
"nmap <kPageDown> gt

" Arrow keys: UDRL => ABCD

" <C-Up> <C-Down> (like ctrl-e/y but with one hand)
nnoremap [1;5A <C-y>
nnoremap [1;5B <C-e>

" compatibility with shell movement (and/or when i wrongfully hold shift)
" Ctrl-arrow (C-Left C-Right) moves across words.
nnoremap [1;5C w
nnoremap [1;5D b
" Ctrl-Shift-arrow (C-S-Left C-S-Right) moves across shell words (non-space).
nnoremap [1;6C W
nnoremap [1;6D B

" don't clear the screen (no termcap) when exiting vim or executing external commands
set t_ti= t_te=

" 256 color detection works
" (at least with gnome-terminal TERM=xterm-256color tmux TERM=screen-256color)
" Currently with xfce4-terminal and tmux everything ends up bold.
if &term =~ "-256color" && $XDG_CURRENT_DESKTOP == "XFCE" && $TMUX != ""
  "set t_Co=256
  set t_AB=[48;5;%dm
  set t_AF=[38;5;%dm
endif

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

" }}}
" load man pages in another window {{{

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
		else
			echoe "Man plugin not found"
		endif
	endfunction
end

" }}}

" highlight conflict markers
au BufReadPost * call matchadd("ErrorMsg", '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$')
" highlight todo messages in any syntax
au BufReadPost * call matchadd("ToDo", '\c\v(TODO|FIXME|NOTE|XXX|HACK|TBD|EXPERIMENTAL|BODGE)')

" [ colorscheme ] {{{

if $SOLARIZED > 0
  Plug 'altercation/vim-colors-solarized'
  let g:solarized_termtrans=1
  if $SOLARIZED == 256
    let g:solarized_termcolors=256
  endif
  colorscheme solarized
elseif filereadable(expand("~/.vim/colors/wounded.vim")) | colorscheme wounded | endif

" }}}

" [filetype / syntax] {{{
" Do filetype then syntax in case the ftplugin customizes the syntax defs.
" vim-plug does this so we don't need to do it again.
if !exists("*plug#end")
  filetype plugin indent on
  syntax enable
endif
" }}}

" Now setup autocommands to match file types.
au FileType clojure exe "RainbowParenthesesLoadRound" | RainbowParenthesesActivate

" Show me EN SPACE characters when I copy text from hipchat.
match Error /\%u2002/


" restore previous cursor position (:help last-position-jump)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" open the fold if the initial position is inside one
au BufWinEnter * if !exists("b:did_zv") | exe "normal zv" | let b:did_zv = 1 | endif

runtime macros/new_file_autocommands.vim

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

" simulate readline in command mode {{{

cnoremap <C-A> <Home>
cnoremap <C-E> <End>
" make alt-D delete the next word by moving over and then deleting back
cnoremap <A-D> <C-Right><C-W>
" my terminal makes it an escape
cmap d <A-D>

" }}}
" [ commands ] {{{

" stupid fingers (either too fast or too slow...)
command -nargs=? -complete=dir -complete=file W w <args>
command -nargs=+ -complete=dir -complete=file Grep grep <args>
command -bang Q q<bang>
command -bang Qall qall<bang>
command Wq wq
command WQ wq
command Wn wn
command WN wN
command Args args
command -nargs=? -complete=dir -complete=file Sp sp <args>

command! Mkpath call mkdir(expand("%:h"), 'p')

command EightyCharacters call MaxLineLength(80)
command -nargs=? MaxLineLength call MaxLineLength(<f-args>)

command! ModeLine exe "norm O" . substitute(&cms, ' \?%s', " vim: set ts=2 sts=2 sw=2 expandtab smarttab:", '')

" using named register ("p) is easier than escaping expr reg ("=)
"command! -nargs=1 -bang -complete=expression Put let @p = <args> | put<bang> p
command! -nargs=1 -bang -complete=expression Put call append(line(".") - ('<bang>' == '!' ? 1 : 0), <args>)

command -nargs=1 -complete=option 	Set 	set <args>
command -nargs=1 -complete=expression   Echo  echo <q-args>
command -nargs=1 -range				PerlDo 	call PerlDo(<q-args>)
command -nargs=1 -complete=file 	Rename 	call RenameCurrent(<q-args>)
command -nargs=+ -range 			CommentSection call CommentSection(<f-args>)

command -nargs=1 FoldComments	call FoldComments(<f-args>)
command! -nargs=1 TabWidth exe "setlocal ts=" . <args> . " sts=" . <args> . " sw=" . <args>

if exists("+cursorline")
  command HighlightPosition set cursorcolumn! cursorline!
endif

command -nargs=1 -complete=dir -complete=file Arge 99arge <args>

command SynStack for id in synstack(line("."), col(".")) | echo synIDattr(id, "name") . " => " . synIDattr(synIDtrans(id), "name") | endfor

command -range=% TabbedToAsciiTable <line1>,<line2>! perl -MText::ASCIITable -e '$t = Text::ASCIITable->new; $t->setCols(split(/\t/, scalar <STDIN>)); $t->addRow(split(/\t/)) for <STDIN>; print $t'
" }}}

" [ mappings ] {{{
" <Leader> == 'mapleader' (default: "\")
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

" re-highlight last search without moving cursor
nmap <Leader>/h :set hlsearch<CR>
" unhighlight last search
nmap <Leader>/n   :nohlsearch<CR>

" retab (remove the tabs from) the current line
nnoremap <Leader><Tab> :.retab<CR>
vnoremap <Leader><Tab> :retab<CR>gv

" maximize current window
nmap <C-w>* <C-w>_<C-w>\|


" Change gf and ^W^F to limit their searches to files (ignore directories).
nnoremap gf :call EditFindCFile("e")<CR>
nnoremap <C-w>f :call EditFindCFile("sp")<CR>
nmap <C-w><C-f> <C-w>f

function! EditFindCFile(cmd)
  return EditFindFile(a:cmd, expand("<cfile>"))
endfunction

function! EditFindFile(cmd, file)
  let l:file = FindFileHarder(a:file)
  if strlen(l:file)
    exe a:cmd l:file
  else
    echom a:file "not found in" &path
  endif
endfunction

function! FindFileHarder(file)
  let l:done = {}
  let l:exprs = [
    \ 'a:file',
    \ 'substitute(a:file, "^\./", "", "")',
    \ 'eval(substitute(&includeexpr, "\\<v:fname\\>", "a:file", ""))',
  \ ]

  for l:expr in l:exprs
    let l:file = eval(l:expr)

    " Ignore duplicates.
    if has_key(l:done, l:file)
      continue
    endif

    let l:ff = findfile(l:file)
    if strlen(l:ff)
      return l:ff
    endif

    let l:done[l:file] = 1
  endfor

  " Emulate return of a single findfile() call.
  return ''
endfunction

"goto file by adding it to the argument list
nmap <Leader>gf gf:$arge %<CR>
nmap <Leader>F 			:99arge <cfile><CR>

map <Leader>o :call <SID>SpaceLines()<CR>

nmap <Leader>J			gJkgJ
"CamelCase -> underscore
nmap <silent> <Leader>_ 	i_gu2l
vmap <silent> <Leader>_ 	<Esc>:set lz<CR>`>a`<i:s/\v([a-z])([A-Z])/\1_\l\2/g<CR>gJkgJ:set nolz<CR>:redraw<CR>:silent noh<CR>
"mappings for dynamic characters
" b takes the next character (c, d, x, y, v)
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
" FIXME: make text objects?
nmap <silent> <Leader>s 	:<C-U>call SurroundCword(0)<CR>
nmap <silent> <Leader>S 	:<C-U>call SurroundCword(1)<CR>
nmap <silent> <Leader>t 	:<C-U>call SurroundTill(0,0)<CR>
nmap <silent> <Leader>T 	:<C-U>call SurroundTill(0,1)<CR>
nmap <silent> <Leader>r 	:<C-U>call SurroundTill(1,1)<CR>
nmap <silent> <Leader>R 	:<C-U>call SurroundTill(1,0)<CR>
vmap <silent> <Leader>s 	:call SurroundSelection()<CR>

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

" }}}

" [ functions ] {{{

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

" wrap visual selection in a commented [section] block
function CommentSection(section) range
  let section = "[ " . a:section . " ]"
  exe "norm '>o" . printf(&commentstring, " } " . section)
  exe "norm '<O" . printf(&commentstring, " "   . section . " {")
endfunction

function <SID>SpaceLines() range
  let l:pos = getpos(".")
  exe "norm " . a:firstline . "GO" . (a:lastline + 1) . "Go"
  let l:pos[1] += 1
  call setpos(".", l:pos)
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
command -nargs=+  Highlight  call Highlight(<q-args>)
let s:dynamicHighlight=0
function Highlight(hl)
  let s:dynamicHighlight = s:dynamicHighlight + 1
  let l:dhlmatch = "dynamicHighlight" . s:dynamicHighlight
  let l:hl = (&ignorecase ? "\\c" : "") . a:hl
  exe "highlight " . l:dhlmatch . " cterm=bold,underline ctermbg=white ctermfg=" . s:dynamicHighlight
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
  let l:idx = stridx(          "()[]{}<>«»", a:character )
  return l:idx > -1 ? strpart( ")(][}{><»«", l:idx, strlen(a:character) ) : a:character
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
      exe "normal! " . ( a:0 >= 5 ? a:5 : "" ) . surround . ( a:0 >= 4 ? a:4 : beginBound . ( rBounds ? strlen( leftside ) . "l" : "" )  )
		else
			let surround = "i" . leftside . rightside . "\e"
			let rightsidelen = ( strlen( rightside ) - 1 )
      execute "normal! " . surround . ( rightsidelen ? rightsidelen . "h" : "" )
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
    execute "normal! " . ( a:0 >= 4 ? a:4 : "" ) . "`>a" . rightside . "\e`<" . "i" . leftside . "\e" . ( a:0 >= 3 ? a:3 : "" )
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

" [ diff ] {{{

command! -bar DiffHelpers call DiffHelpers()
let s:prediff_fold_column = &foldcolumn
function! DiffHelpers()
  if &diff
    augroup DiffHelpers
      au!
      autocmd CursorHold * if &diff | diffupdate | endif
    augroup END
    nnoremap <buffer> du :diffupdate<CR>
  else
    silent! augroup! DiffHelpers
    nunmap <buffer> du
    let &foldcolumn = s:prediff_fold_column
  endif
endfunction

" if diff is set on load (vimdiff), load DiffHelpers right away
if &diff | DiffHelpers | endif

command! -bar DiffThis diffthis | DiffHelpers
command! -bar DiffThese diffthis | wincmd p | diffthis | wincmd p | DiffHelpers

command! -bar DiffToggle windo if &diff | diffoff | DiffHelpers | else |
  \ if &buftype == "" | DiffThis | endif | endif
nmap <Leader>dt :DiffToggle<CR>

" }}}

" Remove duplicate entries that end up in path.
let &path = join(UniqAll(split(&path, ',')), ',')

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

" :Ni!
set secure " last
set noexrc
