if getline(1) =~ "^\[%" | let b:tt2_syn_inc_perl = 0 | call LoadSyntax('tt2') | endif
