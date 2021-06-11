" whitespace formatting {{{

" defined by language
autocmd  FileType make     setlocal ts=8 sts=8 sw=8 noexpandtab
autocmd  FileType markdown setlocal ts=4 sts=4 sw=4   expandtab
autocmd  FileType go       setlocal noexpandtab

" hugo
autocmd BufRead layouts/*.html setfiletype gohtmltmpl
" autocmd BufRead content/*.md setfiletype gomarkdown

" Turn spell check on for documents (and code comments).
let s:spell_types = [
  \ 'css',
  \ 'cpanchanges',
  \ 'gitcommit',
  \ 'html',
  \ 'markdown',
  \ 'rst',
  \ 'ruby',
  \ 'scss',
\ ]
exe "autocmd  FileType " . join(s:spell_types, ',') . " setlocal spell spelllang=en_us"

" }}}
" custom file types {{{

autocmd  BufNewFile,BufRead *.bb                                        setf clojure       " babashka
autocmd  BufNewFile,BufRead *.csv                                       setf csv
autocmd  BufNewFile,BufRead .env.*                                      setf sh
autocmd  BufNewFile,BufRead *.fnl                                       setf lisp          " fennel
autocmd  BufNewFile,BufRead .gitignore                                  setf gitignore
autocmd  BufNewFile,BufRead *.hx                                        setf haxe
autocmd  BufReadPost        Jenkinsfile*                                setf groovy
autocmd  BufNewFile,BufRead *.joke,.joker                               setf joker
autocmd  BufNewFile,BufRead *.imap                                      setf mail
autocmd  BufNewFile,BufRead *.inputrc,.inputrc*                         setf readline
autocmd             BufRead *.md                                        setf markdown
autocmd             BufRead *.npmrc                                     setf dosini
autocmd  BufNewFile,BufRead *.pshrc,*.psgi                              setf perl
autocmd  BufNewFile,BufRead *.porklog                                   setf porklog
autocmd  BufNewFile,BufRead *.rxml,*.rake,*.irbrc,.irbrc,.irb_history   setf ruby
autocmd  BufNewFile,BufRead Vagrantfile,_Vagrantfile                    setf ruby
autocmd  BufNewFile,BufRead *.sc                                        setf scala
autocmd  BufNewFile,BufRead *.screenrc,.screenrc*                       setf screen
autocmd  BufNewFile,BufRead tox.ini                                     setf cfg
autocmd  BufNewFile,BufRead *.tsx                                       setf typescript
autocmd  BufNewFile,BufRead *.wsgi                                      setf python
autocmd             BufRead *                                           call SetFiletypeFromShebang(getline(1))

if !exists("g:filetypeFromShebang")
  let g:filetypeFromShebang = {
    \ 'bb': 'clojure',
    \ 'joker': 'joker',
    \ 'plackup': 'perl',
    \ }
  function SetFiletypeFromShebang(line)
    let l:parts = split(a:line, " ")
    if len(l:parts) > 1 && l:parts[0] == "#!/usr/bin/env"
      let l:base = fnamemodify(l:parts[1], ":t")
      let l:ft = get(g:filetypeFromShebang, l:base, "")
      if l:ft != ""
        exe "setf " l:ft
      end
    end
  endfunction
endif

" fake one, just color it a little bit
autocmd  BufNewFile,BufRead CHANGELOG,HACKING,INSTALL,README,README.txt,TODO        call s:setfReadme()

func! s:setfReadme()
  if getline(1) == '---'
    setf yaml
  else
    setf readme
  endif
endfunc

" }}}

" try again, w/o the .extra_extension at the end
"autocmd  BufNewFile,BufRead *.svn-base,*.bak,*.bkp      let f = expand("<amatch>") | exe "doautocmd BufNewFile,BufRead " . f[:strridx(f, ".")-1]

" warn me when editing a file that doesn't have a modeline
" (need to escape the backslashes)
"autocmd  FileType * if join(getline(1,2)) !~ "vim:\\s*set\\s.\\+:" | echohl ToDo | echomsg "Vim modeline not found at the top" | echohl None | endif
