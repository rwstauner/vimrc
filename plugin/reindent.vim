fun! Reindent(ts) range
  setl noet
  let &l:ts = a:ts
  let &l:sw = a:ts
  let &l:sts = a:ts
  '<,'>retab!
  setl ts=2 sw=2 sts=2 et
  '<,'>retab!
  g;
endfun
com! -range=% -nargs=1 Reindent <line1>,<line2>call Reindent(<args>)
