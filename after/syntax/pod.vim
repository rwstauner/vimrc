"syn region podFormat start="[IBSCLFX]<[^<]"me=e-1 end=">" oneline keepend contains=podFormat,@NoSpell
"syn region podFormat start="[IBSCLFX]<<\s" end="\s>>" oneline keepend contains=podFormat,@NoSpell

" Pod::Weaver commands
syn match podCommand  "^=\(class_method\|method\|attr\|func\)"  nextgroup=podCmdText contains=@NoSpell

hi link podCommand    Special
