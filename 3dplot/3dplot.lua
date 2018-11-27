#!/usr/bin/env luajit
local fmt=string.format
local write=io.write
local int,sqrt=math.floor, math.sqrt
function fna(z) 
	return 30*math.exp(-z^2/100)
end
function string:plot(x)
	return self:sub(1,x-1).."*"..self:sub(x+1)
end
function tab(x)	return (" "):rep(x) end
function center(len, str) return tab(.5*(len-#str))..str end



write(center(55, "3D PLOT\n"),
	center(55, "CHAOTIC COMPUTING HAMBURG, GERMANY\n"),
	center(55,"CONVERTED FROM BASIC TO LUA 2018 (CC-ZERO)\n\n\n"))

for x=-30,30,1.5 do
	local l=0
	local y1=5*int(sqrt(900-x^2)/5)
	local str=(" "):rep(70)
	for y=y1,-y1,-5 do
		local z=int(25+fna(sqrt(x^2+y^2))-.7*y)
		if z>l then 
			l=z
			str=str:plot(z)
		end
	end
	print(str)
end
