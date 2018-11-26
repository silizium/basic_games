local write=io.write
local int, sqrt=math.floor, math.sqrt
local fmt=string.format

function velalt()
	local dv=dt*thrust/mass
	local newvel=vel+step*dt+grav*(-dv-dv*dv/2-dv^3/3-dv^4/4-dv^5/5)
	local newalt=alt-step*dt^2/2-vel*dt+grav*dt*(dv/2+dv^2/6+dv^3/12+dv^4/20+dv^5/30)
	return newvel, newalt
end

function simstep()
	secs=secs+dt
	simtime=simtime-dt
	mass=mass-dt*thrust
	alt=newalt
	vel=newvel
	return
end


write((" "):rep(33), "LUNAR\n", (" "):rep(15),
	"CREATIVE COMPUTING MORRISTOWN, NEW JERSEY\n\n\n",
	"THIS IS A COMPUTER SIMULATION OF AN APOLLO LUNAR\n",
	"LANDING CAPSULE.\n\n",
	"THE ON-BOARD COMPUTER HAS FAILED (IT WAS MADE BY\n",
	"XEROX) SO YOU HAVE TO LAND THE CAPSULE MANUALLY.\n")

repeat
	write("\nSET BURN RATE OF RETRO ROCKETS TO ANY VALUE BETWEEN\n",
		"0 (FREE FALL) AND 200 (MAXIMUM BURN) POUNDS PER SECOND.\n",
		"SET NEW BURN RATE EVERY 10 SECONDS.\n\n",
		"CAPSULE WEIGHT 32,500 LBS; FUEL WEIGHT 16,500 LBS.\n",
		"\n\n\nGOOD LUCK\n")

	secs=0
	print("\nSEC  MI + FT","MPH","LB FUEL","BURN RATE\n") 
	alt,vel,mass,emass,step,grav=120,1,33000,16500,1e-03,1.8

	::io_state::
		write(fmt("%3d   %3d %-4d %9.2e %6.0f  >? ",
			secs, int(alt), int(5280*(alt-int(alt))), 3600*vel, mass-emass))
		thrust=io.read("*n")
		simtime=10 	-- seconds until next input

	::check_fuel::
		if mass-emass>=1e-03 then 
		    if simtime<1e-03 then goto io_state end
			dt=simtime
			if mass<emass+dt*thrust then
				dt=(mass-emass)/thrust
			end
			newvel, newalt=velalt()
			if newalt<=0 then goto simulation end	-- ****
			if vel>0 and newvel<0 then 
				repeat 
					local vstep=(1-mass*step/(grav*thrust))/2
					dt=mass*vel/(grav*thrust*(vstep+sqrt(vstep^2+vel/grav)))+.05
					newvel, newalt=velalt()
					if newalt<=0 then goto simulation end
					simstep()
					if newvel>0 then goto check_fuel end
				until vel<=0 
				goto check_fuel
			end
			simstep()
			goto check_fuel
		end

		write("FUEL OUT AT ",L," SECONDS\n")
		dt=(-vel+sqrt(vel^2+2*alt*step))/step
		vel=vel+step*dt
		secs=secs+dt
		--Next state: outcome
		--End State: check fuel

	--[[
		State: Outcome
		Printing the outcome of the simulation
	]]
	::outcome::
		local mph=3600*vel
		write("ON MOON AT ",secs," SECONDS - IMPACT VELOCITY ",mph," MPH\n")
		if mph<=1.2 then 
			print("PERFECT LANDING!")
			goto try_again 
		elseif mph<=10 then 
			print("GOOD LANDING (COULD RE BETTER)")
			goto try_again 
		elseif mph<=60 then
			write("CRAFT DAMAGE... YOU'RE STRANDED HERE UNTIL A RESCUE\n",
				"PARTY ARRIVES. HOPE YOU HAVE ENOUGH OXYGEN!\n")
			goto try_again
		end
		write("SORRY THERE WERE NO SURVIVORS. YOU BLEW IT!\n",
			"IN FACT, YOU BLASTED A NEW LUNAR CRATER ",mph*.227," FEET DEEP!\n")
		goto try_again
		-- End State: Outcome

		--[[
			State: simulation
			Main routine for simulating 
			approach of lander
		]]
	::simulation::	 
		while dt>=5e-03 do
			local dv=vel+sqrt(vel^2+2*alt*(step-grav*thrust/mass))
			dt=2*alt/dv
			newvel,newalt=velalt()
			simstep()
		end
		goto outcome
		-- End State: simulation


	--[[
		State: try_again
		Asks to repeat the approach
	]]
	::try_again::
	print("\n\n\nTRY AGAIN??")
until false
