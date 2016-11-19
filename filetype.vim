" whitespace formatting {{{

" defined by language
autocmd  FileType make     setlocal ts=8 sts=8 sw=8 noexpandtab
autocmd  FileType markdown setlocal ts=4 sts=4 sw=4   expandtab

" personal preference
let s:styled_types = [
  \ 'awk',
  \ 'cfg',
  \ 'css',
  \ 'cpanchanges',
  \ 'coffee',
  \ 'Dockerfile',
  \ 'eco',
  \ 'haskell',
  \ 'html',
  \ 'mako',
  \ 'java',
  \ 'javascript',
  \ 'json',
  \ 'less',
  \ 'perl',
  \ 'php',
  \ 'puppet',
  \ 'pod',
  \ 'python',
  \ 'ruby',
  \ 'eruby',
  \ 'rst',
  \ 'scala',
  \ 'scss',
  \ 'sh',
  \ 'sql',
  \ 'text',
  \ 'tmux',
  \ 'typescript',
  \ 'vim',
  \ 'xhtml',
  \ 'zsh'
\ ]
exe "autocmd  FileType " . join(s:styled_types, ',') . " SourceCodeStyle"

" Turn spell check on for documents.
let s:spell_types = [
  \ 'cpanchanges',
  \ 'gitcommit',
  \ 'html',
  \ 'markdown',
  \ 'rst',
\ ]
exe "autocmd  FileType " . join(s:spell_types, ',') . " setlocal spell spelllang=en_us"

" }}}
" custom file types {{{

autocmd  BufNewFile,BufRead *.as                                        setf actionscript           " instead of setf atlas
autocmd  BufNewFile,BufRead *.bashrc,.bashrc*                           call SetFileTypeSH("bash")
autocmd  BufNewFile,BufRead .bash_completion*,bash_completion           call SetFileTypeSH("bash")
autocmd  BufNewFile,BufRead *.bsh                                       setf java                   " BeanShell
autocmd  BufNewFile,BufRead .env.*                                      setf sh
autocmd  BufNewFile,BufRead .gitignore                                  setf gitignore
autocmd  BufNewFile,BufRead *.hx                                        setf haxe
autocmd  BufNewFile,BufRead *.imap                                      setf mail
autocmd  BufNewFile,BufRead *.inputrc,.inputrc*                         setf readline
autocmd  BufNewFile         *.md                                        echoe ".md is not markdown"
autocmd             BufRead *.md                                        setf markdown
autocmd  BufNewFile,BufRead *.pshrc,*.psgi                              setf perl
autocmd             BufRead *.cgi                                       if getline(1) =~ "/plackup" | setf perl | endif
autocmd  BufNewFile,BufRead *.porklog                                   setf porklog
autocmd  BufNewFile,BufRead *.rxml,*.rake,*.irbrc,.irbrc,.irb_history   setf ruby
autocmd  BufNewFile,BufRead Vagrantfile,_Vagrantfile                    setf ruby
autocmd  BufNewFile,BufRead *.sc                                        setf scala
autocmd  BufNewFile,BufRead *.screenrc,.screenrc*                       setf screen
autocmd  BufNewFile,BufRead tox.ini                                     setf cfg
autocmd  BufNewFile,BufRead *.wsgi                                      setf python

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
