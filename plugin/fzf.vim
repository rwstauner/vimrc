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

" FZFRg ... " Use rg to populate FZF list.
" :FZFCommands " To see all available lists.

" In FZF use <C-n> / <C-p> for next/prev search history.
let g:fzf_history_dir = '~/.local/cache/vim-fzf-history'
for map_type in g:map_prefixes
  exe 'command! -bar -bang ' . g:fzf_command_prefix . 'Maps' . map_type . ' call fzf#vim#maps("' . map_type . '", <bang>0)'
endfor

" if have('nvim') && !exists('g:fzf_layout')
"   autocmd FileType fzf setl ...
"     \| autocmd BufLeave <buffer> setl back...
" endif

" After global settings.
packadd fzf
packadd fzf.vim

" Insert mode completion of dictionary words.
inoremap <expr> <c-x><c-w> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})
" Insert mote completion of files.
inoremap <expr> <c-x><c-g> fzf#vim#complete#path('rg --files')

nnoremap <leader><C-b> :FZFBLines<CR>
nnoremap <leader><C-l> :FZFLines<CR>
nnoremap <leader><C-t> :exe "FZFTags " expand("<cword>")<CR>
nmap <leader><C-m> <plug>(fzf-maps-n)
xmap <leader><C-m> <plug>(fzf-maps-x)
omap <leader><C-m> <plug>(fzf-maps-o)

function! FZFInsert()
  return trim(system("fzf-tmux -p -"))
endfunction

cnoremap <C-F> <C-R>=FZFInsert()<CR>
