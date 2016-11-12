//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

function GExtension:InitTickets(callback)
	self:Query("SELECT * FROM gex_tickets;", _, function(data)
		for _, ticket in pairs(data) do
			if not self.Tickets[ticket["steamid64"]] or not istable(self.Tickets[ticket["steamid64"]]) then
				self.Tickets[ticket["steamid64"]] = {}
			end

			self.Tickets[ticket["steamid64"]][ticket["id"]] = ticket
		end

		if callback then
			callback()
		end
	end)
end

hook.Add("GExtensionInitialized", "GExtension_Tickets_GExtensionInitialized", function()
	GExtension:InitTickets()

	hook.Add("GExtensionPlayerInitialized", "GExtension_Tickets_GExtensionPlayerInitialized", function(ply)
		if GExtension.Tickets[ply:SteamID64()] then
			for _, ticket in pairs(GExtension.Tickets[ply:SteamID64()]) do
				if not tobool(ticket["seen_user"]) then
					GExtension:AddToConnectMessage(ply, GExtension:FormatString(GExtension:Lang("ticket_responded_admin"), {ticket["subject"]}))
				end
			end
		end
	end)

	for _, command in pairs(GExtension.TicketCmds) do
		GExtension:RegisterChatCommand(command, function(ply)
			ply:SendLua([[gui.OpenURL("]] .. GExtension.WebURL .. [[?t=tickets")]])
		end)
	end

	timer.Create("GExtension_Tickets_Refresh", 300, 0, function()
		GExtension:InitTickets()
	end)
end)