proc/get_all_clients()
	var/list/client/clients = list()

	for (var/mob/M in player_list)

		clients += M.client

	return clients

proc/get_all_admin_clients()
	var/list/client/clients = list()

	for (var/client/C in admin_list)

		clients += C

	return clients


/mob/verb/who()
	set name = "Who"
	set category = "OOC"

	usr << "<b>Current Players:</b>"

	var/list/peeps = list()

	for (var/client/C in client_list)
		var/entry = ""
		if (C.stealth && !usr.client.holder)
			entry += "\t[C.fakekey]"
		else
			entry += "\t[C.key][C.stealth ? " <i>(as [C.fakekey])</i>" : ""]"

		if(usr.client.holder)
			var/mob/M = C.mob
			entry += " - Playing as [M.real_name]"
			switch(M.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isobserver(M))
						var/mob/dead/observer/O = M
						if(O.started_as_observer)
							entry += " - <font color='gray'>Observing</font>"
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
					else
						entry += " - <font color='black'><b>DEAD</b></font>"
			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"
			entry += " (<A HREF='?src=\ref[src.client.holder];adminmoreinfo=\ref[M]'>?</A>)"

		peeps += entry

	peeps = sortList(peeps)

	for (var/p in peeps)
		usr << p

	usr << "<b>Total Players: [length(peeps)]</b>"

/client/verb/adminwho()
	set category = "Admin"
	set name = "Adminwho"

	usr << "<b>Current Admins:</b>"

	for (var/client/C in admin_list)
		if(C && C.holder)
			if(usr.client && usr.client.holder)
				var/afk = 0
				if(C.inactivity > AFK_THRESHOLD ) //When I made this, the AFK_THRESHOLD was 3000ds = 300s = 5m, see setup.dm for the new one.
					afk = 1
				if(isobserver(C.mob))
					usr << "[C] is a [C.holder.rank][C.stealth ? " <i>(as [C.fakekey])</i>" : ""] - Observing [afk ? "(AFK)" : ""]"
				else if(istype(C.mob,/mob/new_player))
					usr << "[C] is a [C.holder.rank][C.stealth ? " <i>(as [C.fakekey])</i>" : ""] - Has not entered [afk ? "(AFK)" : ""]"
				else if(istype(C.mob,/mob/living))
					usr << "[C] is a [C.holder.rank][C.stealth ? " <i>(as [C.fakekey])</i>" : ""] - Playing [afk ? "(AFK)" : ""]"
			else if(!C.stealth)
				usr << "\t[C]  is a [C.holder.rank]"
