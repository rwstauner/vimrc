if g:editor_only
  finish
endif

" TODO: compare to https://github.com/Lokaltog/vim-powerline
let g:statline_fugitive = 1
let g:statline_show_charcode = 0
let g:statline_show_n_buffers = 1
let g:statline_show_encoding = 1
let g:statline_no_encoding_string = 'ascii'
let g:statline_filename_relative = 1
let g:statline_trailing_space = 1
let g:statline_mixed_indent = 1
let g:statline_rvm = 0
let g:statline_rbenv = 0
let g:statline_syntastic = 0

packadd vim-statline
