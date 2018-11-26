#!/usr/bin/env luajit
local write=io.write
local int, sqrt=math.floor, math.sqrt
local fmt=string.format

function velalt(s)
	local dv=s.dt*s.thrust/s.mass
	local nvel=s.vel+s.step*s.dt+s.grav*(-dv-dv*dv/2-dv^3/3-dv^4/4-dv^5/5)
	local nalt=s.alt-s.step*s.dt^2/2-s.vel*s.dt+s.grav*s.dt
		*(dv/2+dv^2/6+dv^3/12+dv^4/20+dv^5/30)
	return nvel, nalt
end

function simstep(s, nalt, nvel)
	s.secs=s.secs+s.dt
	s.simtime=s.simtime-s.dt
	s.mass=s.mass-s.dt*s.thrust
	s.alt=nalt
	s.vel=nvel
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

	print("\nSEC  MI + FT","MPH","LB FUEL","BURN RATE\n") 
	sim={alt=120, vel=1, mass=33000, emass=16500, step=1e-3, grav=1.8, 
		secs=0,thrust=0,simtime=10,dt=0} 

	::io_state::
	do
		write(fmt("%3d   %3d %-4d %9.2e %6.0f  >? ",
			sim.secs, int(sim.alt), int(5280*(sim.alt-int(sim.alt))), 3600*sim.vel, 
			sim.mass-sim.emass))

		sim.thrust=tonumber(io.read("*l")) or sim.thrust
		sim.thrust=math.min(math.max(0, sim.thrust), 200)
		sim.simtime=10 	-- seconds until next input
	end

	::check_fuel::
	do
		if sim.mass-sim.emass>=1e-03 then 
		    if sim.simtime<1e-03 then goto io_state end
			sim.dt=sim.simtime
			if sim.mass<sim.emass+sim.dt*sim.thrust then
				sim.dt=(sim.mass-sim.emass)/sim.thrust
			end
			local nvel, nalt=velalt(sim)
			if nalt<=0 then goto simulation end	
			if sim.vel>0 and nvel<0 then 
				repeat 
					local vstep=(1-sim.mass*sim.step/(sim.grav*sim.thrust))/2
					sim.dt=sim.mass*sim.vel/
						(sim.grav*sim.thrust*(vstep
						+sqrt(vstep^2+sim.vel/sim.grav)))+.05
					nvel, nalt=velalt(sim)
					if nalt<=0 then goto simulation end
					simstep(sim, nalt, nvel)
					if nvel>0 then goto check_fuel end
				until sim.vel<=0 
				goto check_fuel
			end
			simstep(sim, nalt, nvel)
			goto check_fuel
		end

		write("FUEL OUT AT ",sim.secs," SECONDS\n")
		sim.dt=(-sim.vel+sqrt(sim.vel^2+2*sim.alt*sim.step))/sim.step
		sim.vel=sim.vel+sim.step*sim.dt
		sim.secs=sim.secs+sim.dt
	end
		--Next state: outcome
		--End State: check fuel

	--[[
		State: Outcome
		Printing the outcome of the simulation
	]]
	::outcome::
	do
		local mph=3600*sim.vel
		write("ON MOON AT ",fmt("%.1f", sim.secs)," SECONDS - IMPACT VELOCITY ",
			fmt("%.1f", mph)," MPH\n")
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
			"IN FACT, YOU BLASTED A NEW LUNAR CRATER ",
				fmt("%.0f", mph*.227)," FEET DEEP!\n")
		goto try_again
	end
		-- End State: Outcome

		--[[
			State: simulation
			Main routine for simulating 
			approach of lander
		]]
	::simulation::	 
	do
		while sim.dt>=5e-03 do
			local dv=sim.vel+sqrt(sim.vel^2+2*sim.alt
				*(sim.step-sim.grav*sim.thrust/sim.mass))
			sim.dt=2*sim.alt/dv
			local nvel,nalt=velalt(sim)
			simstep(sim, nalt, nvel)
		end
		goto outcome
	end
		-- End State: simulation


	--[[
		State: try_again
		Asks to repeat the approach
	]]
	::try_again::
	do
		print("\n\n\nTRY AGAIN??")
	end
until false
