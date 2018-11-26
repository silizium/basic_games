#!/usr/bin/env luajit
local write=io.write
local int,rnd,abs=math.floor,math.random,math.abs
local fmt=string.format
math.randomseed(os.clock()*os.time()^5)

function tab(x) return (" "):rep(x) end

write(tab(33),"TRAIN\n")
write(tab(15),"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY\n")
repeat
	print("\n\nTIME - SPEED DISTANCE EXERCISE\n")
	local c=rnd(25)+40
	local d=rnd(15)+5
	local t=rnd(19)+20
	write("  A CAR TRAVELING ", c, " MPH CAN MAKE A CERTAIN TRIP IN\n",
		d, " HOURS LESS THAN A TRAIN TRAVELING AT ", t, " MPH.\n",
		"HOW LONG DOES THE TRIP TAKE BY CAR?\n")
	local a=tonumber(io.read("*l")) or 0
	local v=d*t/(c-t)
	local e=int(abs((v-a)*100/a)+.5)
	if e<=5 then 
		write("GOOD! ANSWER WITHIN ", fmt("%.1f", e), " PERCENT.\n")
	else
		write("SORRY.  YOU WERE OFF BY ", fmt("%.1f", e), " PERCENT.\n",
			"CORRECT ANSWER IS ", fmt("%.1f", v), " HOURS.\n\n")
	end
	write("ANOTHER PROBLEM (YES OR NO)? ")
until not io.read("*l"):upper():find("Y")
