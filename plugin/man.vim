" Load man pages in another window.

if g:editor_only
  finish
endif

" Lazy-load the built-in Man command.
if exists(":Man") != 2
  com -nargs=+ Man call ManDelay(<f-args>)

  function ManDelay (cmd)
    let manplugin = expand("$VIMRUNTIME/ftplugin/man.vim")
    if filereadable(manplugin)
      echo "loading Man plugin..."
      delcommand Man
      exe "source " . manplugin
      exe "Man " . a:cmd
    else
      echoe "Man plugin not found"
    endif
  endfunction
end
