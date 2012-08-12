let s:cpo_save = &cpo
set cpo -=C

" call CustomizeHighlight('^tt2.\+', 'ctermbg=236')
" call CustomizeHighlight('^tt2.\+', 'ctermbg=236', 'cterm')
function! CustomizeHighlight(group_re, custom, ...)
  " capture the list of highlight definitions
  redir => l:hi
  silent highlight
  redir END

  let link_re = '\s\+xxx links to\s\+'
  let cleared_re = '\s\+xxx cleared'

  let mode_prefix = a:0 ? a:1 : &term == 'builtin_gui' ? 'gui' : 'cterm'
  let all_attr = split('bold italic reverse inverse standout underline undercurl')

  let cmds = []
  for line in split(l:hi, "\n")
    " for linked groups copy attributes from source group and customize
    if line =~ '^' . a:group_re . link_re
      " determine linked group
      let [group, linked] = split(line, link_re)
      " recursively resolve linked group name (SpecialChar => Special)
      let synid = synIDtrans(hlID(group))

      let synattreval = 'synIDattr(' . synid . ', v:val, "' . mode_prefix . '")'

      " build attributes string
      " get a list of the attributes that are enabled for the linked group
      let attr = filter(all_attr, synattreval)
      let attr_str = empty(attr) ? '' : mode_prefix . '=' . join(attr, ',')

      " build color string
      " get list of lists like ['fg', 1]
      let colors = filter(
          \ map(['fg', 'bg'], '[v:val, ' . synattreval . ']'),
        \ 'v:val[1] >= 0')
      " then put the prefix on when joining to get ctermfg=1
      let color_str = empty(colors) ? '' :
        \ join(map(colors, '"' . mode_prefix . '" . join(v:val, "=")'), '')

      call add(cmds, join(['highlight', group, attr_str, color_str, a:custom], ' '))

    " for any with no highlighting just set the customizations
    elseif line =~ '^' . a:group_re . cleared_re
      " strip everything after the group name
      call add(cmds, 'highlight ' . substitute(line, cleared_re, ' ' . a:custom, ''))
    endif
  endfor

  " execute the highlight commands that were built
  if !empty(cmds)
    exe join(cmds, "\n")
  endif

  " return them so that they can be re-executed later if needed
  return cmds
endfunction

let &cpo = s:cpo_save
