" vim: set fdm=marker:

" For 'tpope/vim-surround':

" Don't make me reach for `y`.
nmap S ys

" Stuff older than that:

" Surround character/selection with spaces.
nnoremap <Leader><space>  i <Esc>la <Esc>
vnoremap <Leader><space>  <Esc>`>a <Esc>`<i <Esc>

" functions {{{

" Csomething generally means current something.
" args: offset (-above or +below cursor)
function Cline(...)
  return getline(line(".") + ( a:0 ? a:1 : 0))
endfunction
" args: offset (-left or +right of cursor)
function Cchar(...)
  return getline(line("."))[col(".") - 1 + ( a:0 ? a:1 : 0)]
endfunction
" args: include_boundaries?
function Cword(...)
  return expand( "<c" . ( a:0 && a:1 ? "WORD" : "word" ) . ">" )
endfunction

" Find the complement to a given character (or return given character).
function MatchPair( character )
  let l:idx = stridx(          "()[]{}<>«»", a:character )
  return l:idx > -1 ? strpart( ")(][}{><»«", l:idx, strlen(a:character) ) : a:character
endfunction

" Find text between characters and perform command on it.
" args: grab-command ([dxy]), inclusive, leftside, rightside
function InBetween(cmd, inclusive, ...)
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
" if Cchar() != rightside
"   execute "normal d" . tillright . rightside
"   call cursor(0, startpos)
" endif
" if Cchar() != leftside
"   execute "normal d" . tillleft . leftside . ( col(".") == startpos - 1 ? "x" : "" )
" endif
  if Cchar() != leftside || ( leftside == rightside && stridx( strpart( Cline(), startpos ), rightside ) == -1 )
    execute "normal " . tillleft . leftside
  endif
    execute "normal " . ( cmd ) . tillright . rightside . ( cmd != "x" ? "" : "x" )
  if cmd == "c"
    normal l
    startinsert
  endif
endfunction

" args: include_boundaries?, leftside, rightside, endcommands, startcommands
function SurroundCword(...) range
  let leftside = ""
  let rightside = ""
  let i = 1
  while i <= v:count1
    let thischar = ( a:0 >= 2 ? a:2 : nr2char( getchar() ) )
    let leftside = leftside . thischar
    let rightside = ( a:0 >= 3 ? a:3 : MatchPair( thischar ) ) . rightside
    let i = ( i + 1 )
  endwhile
    if Cchar() !~ "\\s" && Cline() != "\0"  "if cursor is over a word (not a space or a blank line)
      let rBounds = ( a:0 >= 1 && a:1 ? 1 : 0 )
      if rBounds      "and boundaries are relaxed
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

" args: leftside, rightside, endcommands, startcommands
function SurroundSelection(...) range
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

" args: replacement, tilloutside(farther), till, leftside, rightside
function SurroundTill(r, ...) range
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

function <SID>SpaceLines() range
  let l:pos = getpos(".")
  exe "norm " . a:firstline . "GO" . (a:lastline + 1) . "Go"
  let l:pos[1] += 1
  call setpos(".", l:pos)
endfunction

" }}}

" These are similar to vim-surround but allow for any char to be used.
" TODO: make text objects?
nnoremap <silent> <Leader>s   :<C-U>call SurroundCword(0)<CR>
nnoremap <silent> <Leader>S   :<C-U>call SurroundCword(1)<CR>
nnoremap <silent> <Leader>t   :<C-U>call SurroundTill(0,0)<CR>
nnoremap <silent> <Leader>T   :<C-U>call SurroundTill(0,1)<CR>
nnoremap <silent> <Leader>r   :<C-U>call SurroundTill(1,1)<CR>
nnoremap <silent> <Leader>R   :<C-U>call SurroundTill(1,0)<CR>
vnoremap <silent> <Leader>s   :call SurroundSelection()<CR>

"mappings for dynamic characters
" b takes the next character (c, d, x, y, v)
nnoremap <silent> <Leader>b   :call InBetween("",0)<CR>
nnoremap <silent> <Leader>B   :call InBetween("",1)<CR>
nnoremap <silent> <Leader>c   :call InBetween("c",0)<CR>
nnoremap <silent> <Leader>C   :call InBetween("c",1)<CR>
nnoremap <silent> <Leader>d   :call InBetween("d",0)<CR>
nnoremap <silent> <Leader>D   :call InBetween("d",1)<CR>
nnoremap <silent> <Leader>x   :call InBetween("x",1)<CR>
nnoremap <silent> <Leader>X   :call InBetween("x",0)<CR>
nnoremap <silent> <Leader>v   :call InBetween("v",0)<CR>
nnoremap <silent> <Leader>V   :call InBetween("v",1)<CR>
nnoremap <silent> <Leader>y   :call InBetween("y",0)<CR>
nnoremap <silent> <Leader>Y   :call InBetween("y",1)<CR>

nnoremap <Leader>o :call <SID>SpaceLines()<CR>
