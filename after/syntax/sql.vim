" search the whole buffer for TT tags but don't move the cursor
if search("[%", "nw")
  let b:tt2_sql = 1
elseif search("{{", "nw")
  let b:tt2_sql = 1
  let b:tt2_syn_tags = '{{ }}'
endif
if exists("b:tt2_sql")
  let b:tt2_syn_inc_perl = 0
  call LoadSyntax('tt2')
endif
