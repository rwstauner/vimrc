echom "updating plugins"

packadd minpac

command! -n=1 Add :call minpac#add(<q-args>)
command! -n=1 Opt :call minpac#add(<q-args>, {'type': 'opt'})

call minpac#init()

Opt k-takata/minpac


Opt rwstauner/vim-write-plus

" Add several commands that utilize FZF to display/choose/autocomplete.
Opt junegunn/fzf
Opt junegunn/fzf.vim

" enable repeating certain plugin actions with . (autoloaded)
Add tpope/vim-repeat

" navigate various things back and forth with [x and ]x (t,l,q...)
Opt tpope/vim-unimpaired

" better management of quotes and paired symbols than i used to do
Add tpope/vim-surround

Opt junegunn/vim-easy-align

" toggle comment state with gc<motion>
Opt tpope/vim-commentary

" Read .projections.json for file type metadata.
Opt tpope/vim-projectionist

" Open "file:line" as file at line.
Opt wsdjeg/vim-fetch

" Enable consistent vim/tmux split navigation keys.
Opt christoomey/vim-tmux-navigator

" Use .editorconfig files.  Not necessary for neovim.
Opt editorconfig/editorconfig-vim

" More advanced status line.
Opt millermedeiros/vim-statline

" Common configurations for various LSP's,
Opt neovim/nvim-lspconfig

" perl
"Add vim-perl/vim-perl
Add rwstauner/vim-cpanchanges
Add vim-scripts/perlprove.vim

Add hashivim/vim-terraform

call minpac#clean()
call minpac#update()

call minpac#status()
