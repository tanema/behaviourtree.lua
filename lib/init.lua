-- This is for love so I can just require the folder
local _PACKAGE = string.gsub(...,"%.","/") or ""
return require(_PACKAGE..'/behaviour_tree')

