" search the whole buffer for TT tags but don't move the cursor
if search("[%", "nw") | let b:tt2_syn_inc_perl = 0 | call LoadSyntax('tt2') | endif
