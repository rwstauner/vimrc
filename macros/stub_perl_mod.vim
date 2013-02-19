" this is similar to my dzil template
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
