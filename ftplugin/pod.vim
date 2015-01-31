"POD formatting codes
nmap <silent> <Leader>p   :<C-U>call SurroundCword(0,"<",">","F<i".toupper(nr2char(getchar())))<CR>
nmap <silent> <Leader>P   :<C-U>call SurroundCword(1,"<",">","F<i".toupper(nr2char(getchar())))<CR>
vmap <silent> <Leader>p   :call SurroundSelection("<",">","i".toupper(nr2char(getchar())))<CR>

"POD
"nmap <silent> <Leader>=  :call Pod("n")<CR>
"vmap <silent> <Leader>=  :call Pod("v")<CR>

function! Pod(mode) range "vi mode
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
