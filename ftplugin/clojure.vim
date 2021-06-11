autocmd User ProjectionistDetect
  \ if len(b:projectionist) == 0 |
  \   call projectionist#append(substitute(g:projectionist_file, "\\(^\\|/\\)\\(src\\|test\\)/.\\{-}\\.clj.\\?", "", ""), {
  \     "src/*.clj": {"alternate": "test/{}_test.clj"},
  \     "test/*_test.clj": {"alternate": "src/{}.clj"},
  \   }) |
  \ endif
