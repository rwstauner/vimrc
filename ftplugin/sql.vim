" search the whole buffer for TT tags but don't move the cursor
if search("[%", "nw")
  setlocal commentstring=[%#%s%]
elseif search("{{", "nw")
  setlocal commentstring={{#%s}}
else
  setlocal commentstring=--%s
endif
