" execute command(s) under cursor with lua prefix
nnoremap <buffer> <Leader>: yyq:pIlua <CR>
vnoremap <buffer> <Leader>: "vy:exe "lua " . getreg('v')<CR>
