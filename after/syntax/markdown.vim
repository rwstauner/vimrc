" color this differently (remove the 'transparent' option)
syn region markdownCode matchgroup=markdownCodeDelimiter start="`" end="`" keepend contains=markdownLineStart

hi markdownCode      ctermfg=lightgreen
hi markdownCodeBlock ctermfg=lightgreen
