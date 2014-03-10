syn match cssMozProp contained "-\<moz\>\(-\(transform\)\>\)\="
syn match cssWebKitProp contained "-\<webkit\>\(-\(transform\)\>\)\="

hi def link cssMozProp StorageClass
hi def link cssWebKitProp StorageClass

" this line simply copied from main css file to reprocess the contains argument
syn region cssDefinition transparent matchgroup=cssBraces start='{' end='}' contains=css.*Attr,css.*Prop,cssComment,cssValue.*,cssColor,cssURL,cssImportant,cssError,cssStringQ,cssStringQQ,cssFunction,cssUnicodeEscape
