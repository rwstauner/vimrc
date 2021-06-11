setl suffixesadd=.ts
setl commentstring=//\ %s

autocmd User ProjectionistDetect
  \ if len(b:projectionist) == 0 |
  \   call projectionist#append(substitute(g:projectionist_file, "/\\(src\\|test\\)/.\\{-}\\.ts$", "", ""), {
  \     "*.ts": {"alternate": ["{}.spec.ts", "{}.test.ts"]},
  \     "*.spec.ts": {"alternate": "{}.ts"},
  \     "*.test.ts": {"alternate": "{}.ts"},
  \   }) |
  \ endif
