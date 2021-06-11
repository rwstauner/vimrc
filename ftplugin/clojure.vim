setl formatprg=cljstyle\ pipe

autocmd User ProjectionistDetect
  \ if len(b:projectionist) == 0 |
  \   call projectionist#append(substitute(g:projectionist_file, "\\(^\\|/\\)\\(src\\|test\\)/.\\{-}\\.clj.\\?", "", ""), {
  \     "src/*.clj": {"alternate": "test/{}_test.clj"},
  \     "test/*_test.clj": {"alternate": "src/{}.clj"},
  \     "src/*.cljc": {"alternate": "test/{}_test.cljc"},
  \     "test/*_test.cljc": {"alternate": "src/{}.cljc"},
  \     "src/*.cljs": {"alternate": "test/{}_test.cljs"},
  \     "test/*_test.cljs": {"alternate": "src/{}.cljs"},
  \   }) |
  \ endif
