mob/var/fskamehameha_charge = 'Kamehameha Charge.dmi'
mob/var/gokuskamehameha_charge = 'GokuShhot.dmi'
mob/learn/
	verb
		Father_Son_Kamehameha()
			set category = "Techniques"
			if(usr.doing)
				src << "You are already doing something!"
				return

			if(src.monkey)
				usr << "You cannot use this skill at the moment."
				return

			if(src.wrapped)
				src << "Your ki has been contained in the goo!"
				return

			if(usr.buku)
				return

			if(src.safe)
				src << "You are currently safe and cannot attack."
				return

			if(usr.dead)
				return


			if(usr.safe)
				return

			if(usr.ki_lock)
				src << "Cannot use this Technique at his time"
				return

			if(!usr.pk)
				usr << "You are not a Combatant!"
				return

			for(var/turf/Floors/Safe_Zone/S in view(6))
				if(S in view(8))
					usr << "They are in a Safe Zone!"
					return
			for(var/turf/Planet_Gravitys/Supreme_Kai/A in view(6))
				if(A in view(8))
					usr << "They are in a Safe Zone!"
					return

			for(var/turf/Planet_Gravitys/King_Kai/D in view(6))
				if(D in view(8))
					usr << "They are in a Safe Zone!"
					return


			FSKamehameha_Shoot()
			src.afk_time = 0



mob
	proc
		FSKamehameha_Shoot()
			var/obj/H = new/obj/FSKamehameha
			var/ki_damage = round(usr.powerlevel_max * 410)
			var/ki_cost = round(src.ki_max * 0.65)

			if(src.ki >= ki_cost)
				if(!src.doing)
					src.ki_lock = 1
					spawn(20) src.ki_lock = 0
					src.doing = 1
					src.ki -= ki_cost
					src.overlays += fskamehameha_charge
					view(6) << "<font color = white>[src]:</font> Kame..."
					sleep(8)
					view(6) << "<font color = white>[src]:</font> Ha..."
					sleep(8)
					view(6) << "<font color = white>[src]:</font> ME..."
					sleep(8)
					view(6) << "<font color = white>[src]:</font> HA!!!"
					sleep(8)
					src.overlays += gokuskamehameha_charge
					view(6) << "<font color = white>Goku:</font> MORE POWER ,[src] GIVE IT ALL YOU GOT"
					sleep(8)
					view(6) << "<font color = white>[src]:</font> HAAAAAAAAAAAA!!!!!!!"
					src.overlays -= fskamehameha_charge
					src.overlays -= gokuskamehameha_charge
					usr.icon_state = "attack"
					sleep(3)
					usr.icon_state = ""
					spawn(5) src.doing = 0
					spawn(5) src.frozen = 0
					if(!H)return
					H.dir = src.dir
					H.loc = src.loc

					while(H)
						step(H,H.dir)
						if(!H)break
						var/turf/T = H.loc
						if(T.density)
							del(H)
							break
						for(var/mob/M as mob in T)
							var/absorb_max = round(M.powerlevel_max)
							var/ki_absorbed = round(M.ki_shield_strength - ki_damage)

							if(M == src)
								continue
							if(!M.dead && !M.safe && M.pk)
								if(M.ki_shield)
									if(ki_absorbed >= 1)
										src << "<font color = #00C3ED>[M]'s Ki Shield Absorbs the attacks damage!"
										M << "<font color = #00C3ED>Your Ki Shield Absorbs [src]'s Attack!"
										Explode(new /Effect/BasicBoom(M.loc,1,3))
										M.powerlevel -= round(ki_absorbed)
										M.ki_shield_strength -= round(ki_damage)
										M.BigKiDeathCheck(src)
										src.doing = 0
										src.frozen = 0
										return
									else
										M << "\red [src]'s Father Son Kamehameha slams into you!"
										src <<"\red Your Father Son Kamehameha slams into [M]!"
										Explode(new /Effect/BasicBoom(M.loc,1,3))
										M.powerlevel -= round(ki_absorbed)
										M.ki_shield_strength -= round(ki_damage)
										M.BigKiDeathCheck(src)
										src.doing = 0
										src.frozen = 0
										return
								else
									if(M.absorbing)
										if(absorb_max > ki_damage)
											M << "\red [src]'s attacks hits you, but you Absorb the energy!"
											src <<"\red Your Father Son Kamehameha is Absorbed by [M]!"
											M.gooda+=1
											M.UTBA()
											Explode(new /Effect/BasicBoom(M.loc,1,3))
											M.ki += ki_damage
											src.doing = 0
											src.frozen = 0
											return
										else
											Explode(new /Effect/BasicBoom(M.loc,1,3))
											M.powerlevel -= round(ki_damage)
											M << "\red You try to absorb [src]'s Father Son Kamehameha, but it is too strong!"
											src <<"\red Your Father Son Kamehameha slams into [M]!"
											M.BigKiDeathCheck(src)
											src.doing = 0
											src.frozen = 0
											return

								M << "\red [src.name]'s Father Son Kamehameha slams into you"
								Explode(new /Effect/BasicBoom(M.loc,1,3))
								M.powerlevel -= ki_damage
								M.BigKiDeathCheck(src)
							del(H)
						sleep(1)



obj/FSKamehameha
	icon = 'FSKamehameha.dmi'