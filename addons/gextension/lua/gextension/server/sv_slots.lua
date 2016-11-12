//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

hook.Add("GExtensionInitialized", "GExtension_Slots_GExtensionInitialized", function()
	GExtension.MaxSlots = game.MaxPlayers() - GExtension.RSlotsNumber

	GExtension:UpdateMaxSlots()

	hook.Add("PlayerDisconnected", "GExtension_Slots_PlayerDisconnected", function(ply)
		timer.Create("GExtension_Slots", 0.2, 50, function()
			if not IsValid(ply) then
				timer.Remove("GExtension_Slots")
				GExtension:UpdateMaxSlots()
			end
		end)
	end)

	hook.Add("GExtensionPlayerPostConnectRewards", "GExtension_Slots_GExtensionPlayerPostConnectRewards", function(ply)
		if #player.GetAll() > GExtension.MaxSlots then
			if table.HasValue(GExtension.ReservedSlotPlayers, ply:SteamID64()) then
				local tokick = false

				for _, v in pairs(player.GetAll()) do
					if v:SteamID64() != ply:SteamID64() and not table.HasValue(GExtension.ReservedSlotPlayers, v:SteamID64()) then
						if (IsValid(tokick) && v:TimeConnected() < tokick:TimeConnected()) || (not tokick) then
							tokick = v
						end
					end
				end

				if tokick and IsValid(tokick) then
					tokick:Kick(GExtension:Lang("rslots_kick"))
				else
					ply:Kick(GExtension:Lang("rslots_kick_connect"))
				end
			else
				ply:Kick(GExtension:Lang("rslots_kick_connect_noslot"))
			end
		end
	end)
end)

function GExtension:UpdateMaxSlots()
	RunConsoleCommand("sv_visiblemaxplayers", GExtension.MaxSlots)
end