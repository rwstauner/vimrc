setl includeexpr=v:fname.'/index.js'

let b:syntastic_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = 'node_modules/.bin/eslint'

command! -range RequireToImport <line1>,<line2>g/require/norm! ^cwimportf=cf(from f)x
