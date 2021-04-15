setl includeexpr=v:fname.'/index.js'

command! -range RequireToImport <line1>,<line2>g/require/norm! ^cwimportf=cf(from f)x
