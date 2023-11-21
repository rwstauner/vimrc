" CR shrinks other windows (wincmd |), v does not.

" Netrw Browser Control

let g:netrw_alto         = 0  " open preview at top-left
let g:netrw_browse_split = 2  " vsplit
let g:netrw_fastbrowse   = 2 " only obtain dir when not previously seen
let g:netrw_home         = g:cache_prefix . "netrw"
let g:netrw_liststyle    = 3  " Use tree-mode as default view
let g:netrw_menu         = 1
let g:netrw_preview      = 1  " preview window shown in a vertical split

fun! NetrwPostOpen()
  " Make it appear as though explorer doesn't change:
  " Go back to explorer | re-expand | return to newly opened editor window
  99wincmd h | vertical resize 30 | wincmd p
endfun

let g:Netrw_funcref      = function("NetrwPostOpen") " func ref to call after opening a file

" Make tab work like p (reuse preview window).
fun! NetrwTab(isLocal)
  norm p
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
  \ ["<S-Down>", "NetrwShiftDown"],
  \ ["<S-Up>", "NetrwShiftUp"],
  \ ]
