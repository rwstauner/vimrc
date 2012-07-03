command! -nargs=0 JsOneLineClipboard w ! perl -0777 -ne 's{//.+$}{}mg; s/\n+|\t+/ /g; print;' | clip
