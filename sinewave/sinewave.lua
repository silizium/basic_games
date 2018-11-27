#!/usr/bin/env luajit
local write=io.write
local int,sin=math.floor,math.sin
function tab(x)	return (" "):rep(x) end
function center(len, str) return tab(.5*(len-#str))..str end

write(center(55, "SINE WAVE\n"),
	center(55,"CHAOTIC COMPUTING HAMBURG, GERMANY\n"),
	center(55,"CONVERTED FROM BASIC TO LUA 2018 (CC-ZERO)\n\n\n\n\n"))
-- REMARKABLE PROGRAM BY DAVID AHL
local b=false
for t=0,40,.25 do 
	local a=int(26+25*sin(t))
	write(tab(a))
	if b then 
		write("CREATIVE\n")
		b=true
	else
		write("COMPUTING\n")
		b=false
	end
end
