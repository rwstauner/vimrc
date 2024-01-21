"set tags+=~/.vim/tags/ptags " cpan: Vim::Tags

" cpanm Neovim::Ext

" if has('nvim')
"   let g:perl_host_prog = '/usr/bin/perl'
" endif

" Enable :make to run prove and put test failures in the quickfix.
au BufRead,BufNewFile *.t set filetype=perl | compiler perlprove

" Like :perldo but can use column-based selections.
function PerlDo(pl) range
  "let l:oldpaste = &paste
  set paste
  norm! `>ak
  let l2 = line('.') + 1 " next we'll drop them all down by one
  norm! `<i
  let l1 = line('.')
  exe l1 . "," . l2 . "perldo " . a:pl
  exe l2
  norm! gJ
  exe l1
  norm! kgJ
  set nopaste
endfunction

command -nargs=1 -range				PerlDo 	call PerlDo(<q-args>)

" This is similar to my dzil template.
function StubPerlModule(...)
  let lines = ['package ']
  let path = a:0 ? a:1 : expand('%:p')
  let pkg = substitute(substitute(path, '\v^(.+/)?lib/(.+)\.pm$', '\2', ''), '/', '::', 'g') . ';'
  setlocal ft=perl
  if match(path, '\v(^|/)t/lib/') >= 0
    let lines[0] .= '# no_index'
    call add(lines, repeat(' ', &sw) . pkg)
  else
    let lines[0] .= pkg
    call add(lines, '# ABSTRACT: undef')
    call append(line('$'), ['', '=head1 SYNOPSIS', '', '=head1 DESCRIPTION', '', '=cut'])
  endif
  call append(0, ['use strict;', 'use warnings;', '', ] + lines)
endfunction

au BufNewFile *.pm if match(expand("<afile>"), '\v^(t/)?lib/.+\.pm$') >= 0 | call append(1, ['', '1;']) | call StubPerlModule() | endif
