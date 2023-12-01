if g:editor_only
  finish
endif

" CR shrinks other windows (wincmd |), v does not.

" Netrw Browser Control

let g:netrw_alto         = 0  " open preview at top-left
let g:netrw_browse_split = 2  " 1 h, 2 vsplit

" default                  "noma nomod nonu nowrap ro nobl"
let g:netrw_bufsettings  = "noma nomod   nu nowrap ro nobl winfixwidth foldcolumn=0"

let g:netrw_fastbrowse   = 2 " only obtain dir when not previously seen
let g:netrw_home         = g:cache_prefix . "netrw"
let g:netrw_liststyle    = 3  " Use tree-mode as default view
let g:netrw_menu         = 1
let g:netrw_preview      = 1  " preview window shown in 1: vertical split

let g:netrw_winsize      = -30 " Start explorer at 30 columns wide.

fun! NetrwPostOpen()
  "if len(getwininfo()) > 2
    " q
    " sblast
    "wincmd J
  "endif
endfun
let g:Netrw_funcref      = function("NetrwPostOpen") " func ref to call after opening a file

" Make tab work like p (reuse preview window).
fun! NetrwTab(isLocal)
  norm p
endfun

fun! NetrwCR(isLocal)
  norm p
  wincmd p
endfun

fun! NetrwI(isLocal)
  " Use netrw to vsplit.
  norm v
  " Close it.
  q
  " Go back to editor window.
  wincmd l
  " Open new split with last buffer.
  sblast
endfun

fun! NetrwShiftDown(isLocal)
  if exists(':TmuxNavigateDown')
    TmuxNavigateDown
  else
    wincmd j
  endif
endfun

fun! NetrwShiftUp(isLocal)
  if exists(':TmuxNavigateUp')
    TmuxNavigateUp
  else
    wincmd k
  endif
endfun

let g:Netrw_UserMaps = [
  \ ["<tab>", "NetrwTab"],
  \ ["<cr>", "NetrwCR"],
  \ ["i", "NetrwI"],
  \ ["<S-Down>", "NetrwShiftDown"],
  \ ["<S-Up>", "NetrwShiftUp"],
  \ ]

" Keep explorer window open at specified width. {{{
let s:netrw_width = 30

fun! NetrwWinResized()
  for item in v:event.windows
    let l:winnr = item['winnr']
    if getwinvar(l:winnr, "&ft") == "netrw"
      let l:width = winwidth(l:winnr)
      " Don't save if it's too large (or too small).
      if l:width < (&columns/4) && l:width > 10
        let s:netrw_width = l:width
      else
        let l:ei = &ei
        let &ei = 'WinResized'
        exe "vertical " . l:winnr . "resize " . s:netrw_width
        let &ei = l:ei
      endif
    endif
  endfor
endfun

au WinResized * call NetrwWinResized()
" }}}
