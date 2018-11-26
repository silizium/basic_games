local write=io.write
local int, sqrt=math.floor, math.sqrt
local fmt=string.format

function L420()
	Q=S*K/M
	J=V+G*S+Z*(-Q-Q*Q/2-Q^3/3-Q^4/4-Q^5/5)
	I=A-G*S*S/2-V*S+Z*S*(Q/2+Q^2/6+Q^3/12+Q^4/20+Q^5/30)
	return
end

function L330()
	L=L+S
	T=T-S
	M=M-S*K
	A=I
	V=J
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

	L=0
	print("\nSEC  MI + FT","MPH","LB FUEL","BURN RATE\n") 
	A,V,M,N,G,Z=120,1,33000,16500,1E-03,1.8

	::print_val::
		write(fmt("%3d   %3d %-4d %9.2e %6.0f  >? ",
			L, int(A), int(5280*(A-int(A))), 3600*V, M-N))
		K=io.read("*n")
		T=10 

	::continue::
		if M-N>=1e-03 then 
		    if T<1e-03 then goto print_val end
			S=T
			if M<N+S*K then
				S=(M-N)/K
			end
			L420()
			if I<=0 then goto L340 end	-- ****
			if V>0 and J<0 then 
				goto L370				-- ****
			end
			L330()
			goto continue
		end

		write("FUEL OUT AT ",L," SECONDS\n")
		S=(-V+sqrt(V*V+2*A*G))/G
		V=V+G*S
		L=L+S

		::main_loop::
			W=3600*V
			write("ON MOON AT ",L," SECONDS - IMPACT VELOCITY ",W," MPH\n")
			if W<=1.2 then 
				print("PERFECT LANDING!")
				goto try_again 
			end
			if W<=10 then 
				print("GOOD LANDING (COULD RE BETTER)")
				goto try_again 
			end
			if W<=60 then
				write("CRAFT DAMAGE... YOU'RE STRANDED HERE UNTIL A RESCUE\n",
					"PARTY ARRIVES. HOPE YOU HAVE ENOUGH OXYGEN!\n")
				goto try_again
			end
			write("SORRY THERE NERE NO SURVIVORS. YOU BLOW IT!\n",
				"IN FACT, YOU BLASTED A NEW LUNAR CRATER ",W*.227," FEET DEEP!\n")
			goto try_again

		::L340::		-- **** 
		if S<5e-03 then goto main_loop end
		D=V+sqrt(V*V+2*A*(G-Z*K/M))
		S=2*A/D
		L420()
		L330()
		goto L340

		::L370::
		repeat 
			W=(1-M*G/(Z*K))/2
			S=M*V/(Z*K*(W+sqrt(W*W+V/Z)))+.05
			L420()
			if I<=0 then goto L340 end
			L330()
			if J>0 then goto continue end
		until V<=0 
	goto continue
	::try_again::
	print("\n\n\nTRY AGAIN??")
until false
