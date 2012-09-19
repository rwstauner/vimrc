" whitespace formatting

" defined by language
autocmd  FileType make     setlocal ts=8 sts=8 sw=8 noexpandtab
autocmd  FileType markdown setlocal ts=4 sts=4 sw=4   expandtab
autocmd  FileType yaml     setlocal ts=2 sts=2 sw=2   expandtab

" personal preference
let s:styled_types = [
  \ 'css',
  \ 'cpanchanges',
  \ 'html',
  \ 'javascript',
  \ 'json',
  \ 'less',
  \ 'perl',
  \ 'puppet',
  \ 'pod',
  \ 'python',
  \ 'ruby',
  \ 'eruby',
  \ 'sh',
  \ 'sql',
  \ 'vim',
  \ 'xhtml',
  \ 'zsh'
\ ]
exe "autocmd  FileType " . join(s:styled_types, ',') . " SourceCodeStyle"

" }}}
" custom file types {{{

" custom file types
autocmd  BufNewFile,BufRead *.as                                        setf actionscript           " instead of setf atlas
autocmd  BufNewFile,BufRead *.bashrc,.bashrc*                           call SetFileTypeSH("bash")
autocmd  BufNewFile,BufRead .bash_completion*,bash_completion           call SetFileTypeSH("bash")
autocmd  BufNewFile,BufRead Changes                                     setf cpanchanges
autocmd  BufNewFile,BufRead *.json                                      setf json
autocmd  BufNewFile,BufRead *.imap                                      setf mail
autocmd  BufNewFile,BufRead *.inputrc,.inputrc*                         setf readline
autocmd  BufNewFile,BufRead *.pshrc,*.psgi                              setf perl
autocmd  BufNewFile,BufRead *.porklog                                   setf porklog
autocmd  BufNewFile,BufRead *.rxml,*.rake,*.irbrc,.irbrc,.irb_history   setf ruby
autocmd  BufNewFile,BufRead *.screenrc,.screenrc*                       setf screen

" fake one, just color it a little bit
autocmd  BufNewFile,BufRead CHANGELOG,HACKING,INSTALL,README,README.txt,TODO        call s:setfReadme()

func! s:setfReadme()
  if getline(1) == '---'
    setf yaml
  else
    setf readme
  endif
endfunc
