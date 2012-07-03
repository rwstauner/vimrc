command! CoverageReport so cover_db/coverage.vim

" what's a good default range for perltidy?
command! -range=% PerlTidy <line1>,<line2> ! perltidy

command! PerlTest ! perl -Ilib %

" http://blogs.perl.org/users/marcel_grunauer/2011/07/vim-script-to-fix-the-current-files-package-name.html
"nnoremap <Leader>pa :<C-u>call PerlReplacePackageName()<CR>

function! PerlPackageNameFromFile()
  let filename = expand('%:p')
  let package = substitute(filename, '^.*/lib/', '', '')
  let package = substitute(package, '\.pm$', '', '')
  let package = substitute(package, '/', '::', 'g')
  return package
endfunction

function! PerlReplacePackageName()
  let package = PerlPackageNameFromFile()
  let pos = getpos('.')
  1,/^package\s/s/^package\s\+\zs[A-Za-z_0-9:]\+\ze\(\s\+{\|;\)/\=package/
  call setpos('.', pos)
endfunction

" http://www.dagolden.com/index.php/1539/code-munging-with-vim-if-modifier-to-if-block/
"map ,if V:s/\(\s*\)  if \(.*\);/\1if (\2) {/<CR>kVdp>>$a;<CR><BS>}<CR><Esc>kkk^
