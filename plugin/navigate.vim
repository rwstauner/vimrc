" [ vim-tmux-navigatior ] {{{

let g:tmux_navigator_no_mappings = 1
" let g:tmux_navigator_save_on_switch = 0

packadd vim-tmux-navigator

" S-Left S-Down S-Up S-Right
if has('nvim')
  let s:tmuxnav_prefixes = {
    \'c': '',
    \}
  for map_type in g:map_prefixes
    if map_type != "i"
      exe map_type . 'noremap <silent> <S-Up>    ' . get(s:tmuxnav_prefixes, map_type, "") . ':<C-U>TmuxNavigateUp<cr>'
      exe map_type . 'noremap <silent> <S-Down>  ' . get(s:tmuxnav_prefixes, map_type, "") . ':<C-U>TmuxNavigateDown<cr>'
      exe map_type . 'noremap <silent> <S-Right> ' . get(s:tmuxnav_prefixes, map_type, "") . ':<C-U>TmuxNavigateRight<cr>'
      exe map_type . 'noremap <silent> <S-Left>  ' . get(s:tmuxnav_prefixes, map_type, "") . ':<C-U>TmuxNavigateLeft<cr>'
    endif
  endfor
else
  noremap <silent> [1;2A   :<C-U>TmuxNavigateUp<cr>
  noremap <silent> [1;2B   :<C-U>TmuxNavigateDown<cr>
  noremap <silent> [1;2C   :<C-U>TmuxNavigateRight<cr>
  noremap <silent> [1;2D   :<C-U>TmuxNavigateLeft<cr>
end
" This one doesn't fit :/
noremap <silent> <C-\>     :<C-U>TmuxNavigatePrevious<cr>

" Note: In visual mode the selection won't be preserved
" but this is also the case for regular C-w commands, so that's fine.
" }}}
