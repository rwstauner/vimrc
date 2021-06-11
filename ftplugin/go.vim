autocmd User ProjectionistDetect
  \ if len(b:projectionist) == 0 |
  \   call projectionist#append(substitute(g:projectionist_file, "/[^/]\\{-}$", "", ""), {
  \     "*.go": {"alternate": "{}_test.go"},
  \     "*_test.go": {"alternate": "{}.go"},
  \   }) |
  \ endif
