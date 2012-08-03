" keep ~/.vim ahead of bundles in the list
command! -bar FixRunTimePath set rtp -=$HOME/.vim rtp ^=$HOME/.vim

let s:lazy_bundles = {}

command! -nargs=+ -bar LazyBundle call LazyBundle(<args>)

function! LazyBundle(...)
  if !has_key(s:lazy_bundles, a:1)
    let s:lazy_bundles[ a:1 ] = 1
    " BundleInstall opens a vsplit to show progress (which we don't want here)
    let b = call('vundle#config#bundle', a:000)
    call    vundle#config#require([b])
    FixRunTimePath
  endif
endfunction

" define a command that will load a plugin bundle that redefines the command
command! -nargs=+ -bar LazyCommand call LazyCommand(<f-args>)

function! LazyCommand(cmd, bundle, ...)
  exe "command! -nargs=* " . a:cmd . " LazyBundle " . a:bundle . join(a:000, ' ') . " | " . a:cmd . " <args>"
endfunction

" Load plugin bundles only for certain file types
command! -nargs=+ FTBundle call FTBundle(<f-args>)

function! FTBundle(spec, ...)
  let l:cmd = " LazyBundle " . join(a:000, ' ')

  " vundle doesn't expose a function to get the dir so we try to make a good guess
  let dir = substitute(a:1, "\\v^['\"]?.{-}([^/]{-})(\\.git)?['\"]?$", "\\1", '')
  " pre-load any ftdetect files in the bundles
  for ftdetect in split(glob(g:bundle_dir . "/" . dir . "/ftdetect/*.vim"), "\n")
    exe "source " . ftdetect
  endfor

  " define autocommands to lazy load the bundle
  " TODO: should probably put these in an augroup and then unload it
  for spec in split(a:spec, ';')
    " match filetype
    if match(spec, '^ft=') == 0
      exe "au FileType " . strpart(spec, 3) . l:cmd
    " match file name
    elseif match(spec, '^name=') == 0
      " NOTE: BufReadPre can be used because it occurs before ftplugins are looked up
      exe "au BufReadPre,BufNewFile " . strpart(spec, 5) . l:cmd
    else
      echoerr 'FTBundle: unknown spec: ' . spec
    endif
  endfor
endfunction
