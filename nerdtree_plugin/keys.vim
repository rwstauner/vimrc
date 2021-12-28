" Use API to add mappings without removing the originals.

" help <SNR>
function s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun
let s:sid = '<SNR>' . s:SID() . '_'

call NERDTreeAddKeyMap({ 'key': '<Tab>', 'callback': s:sid."DirTab",  'scope': 'DirNode' })
call NERDTreeAddKeyMap({ 'key':'<Space>','callback': s:sid."DirTab",  'scope': 'DirNode' })
call NERDTreeAddKeyMap({ 'key': '<Tab>', 'callback': s:sid."Tab",     'scope': 'FileNode' })
call NERDTreeAddKeyMap({ 'key':'<Space>','callback': s:sid."Tab",     'scope': 'FileNode' })
call NERDTreeAddKeyMap({ 'key':     '-', 'callback': s:sid."Split",   'scope': 'FileNode' })
call NERDTreeAddKeyMap({ 'key': '<Bar>', 'callback': s:sid."Bar",     'scope': 'FileNode' })

function! s:DirTab(...)
  norm 
endfunction

function! s:Tab(...)
  norm go
endfunction

function! s:Split(...)
  norm gi
endfunction

function! s:Bar(...)
  norm gs
endfunction
