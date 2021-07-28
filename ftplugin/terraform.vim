setlocal iskeyword+=-

" Let me use #/* on a portion of a resource name.
while &l:iskeyword =~ "\\."
  setlocal iskeyword-=.
endwhile
