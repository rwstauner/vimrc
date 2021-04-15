" search the whole buffer for TT tags but don't move the cursor
if search("[%", "nw")
  setlocal commentstring=[%#%s%]
elseif search("{{", "nw")
  setlocal commentstring={{#%s}}
else
  setlocal commentstring=--%s
endif

" setl formatprg=pg_format\ -
" let &l:formatprg='ruby -rpg_query -e "puts PgQuery.parse(STDIN.read).beautify"'
let &l:formatprg='python3 -m sqlparse -r -'

" https://github.com/caesarhu/sql-formatter
" command! -range SQLFormatRuby '<,'>! ruby -rpg_query -e "puts PgQuery.parse(STDIN.read).beautify"
" command! -range SQLFormatPython '<,'>! python -m sqlparse -r -

command! -range=% SQLCopy <line1>,<line2>w ! perl -0777 -pe 's/--.+$//mg; s/\s+/ /g;' | clip
