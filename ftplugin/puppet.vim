" i don't want the => abbreviations b/c it adds noise to my version control
let b:did_ftplugin = 1

setlocal commentstring=#%s

" subtract one letter at a time (:help add-option-flags)
setlocal formatoptions -=t formatoptions -=b
