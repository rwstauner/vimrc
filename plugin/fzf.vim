if g:editor_only
  finish
endif

" Use fzf on anything with call fzf#run(fzf#wrap({'source': 'shell cmd', 'sink': 'vim cmd', 'options': ['fzf args like -m']}))

" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1
function! s:fzf_quickfix(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

" The '' key is for "enter".
let g:fzf_action = {
  \ '': 'split',
  \ 'ctrl-q': function('s:fzf_quickfix'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'edit',
  \ 'ctrl-v': 'vsplit' }

let g:fzf_command_prefix = 'FZF'

" In FZF use <C-n> / <C-p> for next/prev search history.
let g:fzf_history_dir = '~/.local/cache/vim-fzf-history'

" After global settings.
try
  packadd fzf
  packadd fzf.vim

  " FZFRg ... " Use rg to populate FZF list.
  " :FZFCommands " To see all available lists.

  if has('nvim') && !exists('g:fzf_layout')
    " autocmd FileType fzf setl ...
    "   \| autocmd BufLeave <buffer> setl back...
    autocmd FileType fzf tnoremap <buffer> <Esc> <c-c>
  endif

  for map_type in g:map_prefixes
    exe 'command! -bar -bang ' . g:fzf_command_prefix . 'Maps' . map_type . ' call fzf#vim#maps("' . map_type . '", <bang>0)'
  endfor

  " Insert mode completion of dictionary words.
  inoremap <expr> <c-x><c-w> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})
  " Insert mote completion of files.
  inoremap <expr> <c-x><c-g> fzf#vim#complete#path('rg --files')

  nnoremap <leader>fb :FZFBLines<CR>
  nnoremap <leader>fl :FZFLines<CR>
  nnoremap <leader>ft :exe "FZFTags " expand("<cword>")<CR>
  nmap <leader>fm <plug>(fzf-maps-n)
  xmap <leader>fm <plug>(fzf-maps-x)
  omap <leader>fm <plug>(fzf-maps-o)
catch /:E919:/ " plugin not found
  " ignore
endtry

" Poor man's :FZFFiles
if exists("*termopen")
  function! FZFSplit()
    let $VIM_FZF_OUT = tempname()
    new
    setlocal nonu foldcolumn=0
    au! TermClose <buffer> call FZFSplitFinish()
    call termopen("fzf " . &shellpipe . " " . $VIM_FZF_OUT)
    startinsert
  endfunction

  function! FZFSplitFinish()
    let out = readfile($VIM_FZF_OUT)
    call delete($VIM_FZF_OUT)
    let $VIM_FZF_OUT = v:null
    exe "edit " out[0]
    filetype detect
  endfunction

  command! FZFSplit call FZFSplit()
endif

" The fzf-tmux popup window is very nice but not always available.
if exists("$TMUX") && system("command -v fzf-tmux") != ""
  function! FZFInsert()
    return trim(system("fzf-tmux -p -"))
  endfunction
  cnoremap <C-F> <C-R>=FZFInsert()<CR>
else
  " This will delete any prefix on the command line (like "sp ")
  " but it's the way I'm used to activating it.
  cnoremap <C-F> <C-U>call FZFSplit()<CR>
endif
