if g:editor_only
  finish
endif

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
