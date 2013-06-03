" autocommands for new files
autocmd BufNewFile   * let b:is_new_file = 1
autocmd BufWritePre  * if exists("b:is_new_file") | call WritingNewFile('pre')  | endif
autocmd BufWritePost * if exists("b:is_new_file") | call WritingNewFile('post') | endif

function! WritingNewFile(when)
  let l:file = expand("<afile>")
  let l:dir  = fnamemodify(l:file, ':h')

  if a:when == 'pre'
    " automatically mkdir -p before writing a new file
    if !exists("b:made_new_dir") && !isdirectory(l:dir)
      echom "Making directory: " . l:dir
      call mkdir(l:dir, 'p')
      let b:made_new_dir = 1
    endif
  endif

  if a:when == 'post'
    " automatically set exec bit on new files with shebangs
    if getline(1) =~ "^#!.*"
      exe "silent !chmod a+x " . l:file
    endif

    "unlet b:is_new_file
  endif
endfunction
