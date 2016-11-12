//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

util.AddNetworkString("GExtension_Net_RunLua")

hook.Add("GExtensionLoaded", "GExtensionInitialize", function()
	GExtension:InitSQL()
end)

function GExtension:FinishInitializing()
	GExtension:InitServer(function()
		GExtension.Initialized = true
		hook.Run("GExtensionInitialized")

		timer.Simple(5, function()
			for _, ply in pairs(self.ConnectQueue) do
				if IsValid(ply) then
					hook.Run("GExtensionPlayerConnected", ply)
				end
			end

			self.ConnectQueue = {}
		end)
		
	end)
end

hook.Add("GExtensionMySQLConnected", "GExtensionMySQLConnected", function()
	GExtension:InitGroups(function()
		http.Fetch(GExtension.WebURL .. 'api.php?t=timezone', function(body)
			body = string.Trim(body)

			if string.find(body, ":") and #body < 10 then
				--[[local expl = string.Explode(':', body)
				local offsetdec = (tonumber(expl[2])/60) * 100
				self.TimeOffset = tonumber(string.Replace(expl[1], '+', '') .. offsetdec)]]--
				GExtension.TimeOffset = body
				GExtension:Query("SET time_zone = '" .. GExtension.TimeOffset .. "';")
			else
				GExtension:Print("error", "Failed to load timezone. Check the availability of your webserver.")
			end
		end)

		GExtension:InitSettings(function()
			GExtension:InitPlayers(function()
				timer.Create("GExtension_Main_InitWait", 5, 0, function()
					if not string.StartWith(game.GetIPAddress(), '0.0.0.0') then
						GExtension:FinishInitializing()
						
						timer.Create("GExtension_Main_InitRetry", 60, 0, function()
							if not GExtension.Initialized then
								GExtension:FinishInitializing()
							else
								timer.Remove("GExtension_Main_InitRetry")
							end
						end)
					end
				end)
			end)
		end)
	end)
end)

function GExtension:AddToConnectMessage(ply, message, prio)
	if IsValid(ply) then
		timer.Remove("GExtension_ConnectMessage_" .. ply:SteamID64())

		if not GExtension.ConnectMessage[ply:SteamID64()] then
			GExtension.ConnectMessage[ply:SteamID64()] = {}
		end

		if not prio then
			GExtension.ConnectMessage[ply:SteamID64()][#GExtension.ConnectMessage[ply:SteamID64()]+1] = message
		else
			table.insert(GExtension.ConnectMessage[ply:SteamID64()], 1, message)
		end

		timer.Create("GExtension_ConnectMessage_" .. ply:SteamID64(), 5, 1, function()
			GExtension:SendConnectMessage(ply)
		end)
	end
end

function GExtension:SendConnectMessage(ply)
	if IsValid(ply) then
		if GExtension.ConnectMessage[ply:SteamID64()] and istable(GExtension.ConnectMessage[ply:SteamID64()]) then
			if tobool(#GExtension.ConnectMessage[ply:SteamID64()]) then
				ply:GE_PrintToChat("", "")
				ply:GE_PrintToChat("", "")
				ply:GE_PrintToChat("", "")
				ply:GE_PrintToChat("", "")
				ply:GE_PrintToChat("", "")
				ply:GE_PrintToChat("", "")
				ply:GE_PrintToChat("", "")
				ply:GE_PrintToChat("", "")
				ply:GE_PrintToChat("<green>--> " .. self:Lang("information") .. " <--</green>", "")

				for _, message in pairs(GExtension.ConnectMessage[ply:SteamID64()]) do
					ply:GE_PrintToChat(message)
				end

				ply:GE_PrintToChat("", "")
			end
		end

		GExtension.ConnectMessage[ply:SteamID64()] = {}
	end
end

hook.Add("GExtensionInitialized", "GExtension_Main_Welcome_GExtensionInitialized", function()
	GExtension:Print("success", "Initialized")

	hook.Add("GExtensionPlayerInitialized", "GExtension_Main_Welcome_GExtensionPlayerInitialized", function(ply)
		GExtension:AddToConnectMessage(ply, GExtension:FormatString(GExtension:Lang("player_welcome"), {ply:Nick()}), true)
	end)

	timer.Remove("GExtension_Main_InitWait")
end)

function GExtension:PrintToChat(message, steamid64_exception, tag, color)
	if SERVER then
		for k, ply in pairs(player.GetHumans()) do
			if not steamid64_exception || ply:SteamID64() != steamid64_exception then
				ply:GE_PrintToChat(message, tag, color)
			end
		end
	end
end

function GExtension:CreateColorMessage(message)
	message = string.Replace(message, '"', '')
	message = string.Replace(message, '<red>', '", Color(255, 24, 35), "')
	message = string.Replace(message, '</red>', '", Color(255, 255, 255), "')
	message = string.Replace(message, '<green>', '", Color(45, 170, 0), "')
	message = string.Replace(message, '</green>', '", Color(255, 255, 255), "')
	message = string.Replace(message, '<blue>', '", Color(0, 115, 204), "')
	message = string.Replace(message, '</blue>', '", Color(255, 255, 255), "')
	message = string.Replace(message, '<yellow>', '", Color(229, 221, 0), "')
	message = string.Replace(message, '</yellow>', '", Color(255, 255, 255), "')
	message = string.Replace(message, '<pink>', '", Color(229, 0, 218), "')
	message = string.Replace(message, '</pink>', '", Color(255, 255, 255), "')

	return message
end

function meta_ply:GE_PrintToChat(message, tag, color)
	if SERVER then
		if IsValid(self) then
			if not GExtension.Tag then
				GExtension.Tag = "GExtension"
			end

			if not tag then
				tag = [[Color(0, 187, 255), "[]] .. GExtension.Tag .. [[] ", ]]
			end

			if not color then
				color = [[255, 255, 255]]
			end

			message = string.Replace(message, '\r', '')
			message = string.Replace(message, '\n', '')

			message = GExtension:CreateColorMessage(message)

			local tosend = [[chat.AddText(]] .. tag .. [[Color(]] .. color .. [[), "]] .. message .. [[" )]]

			net.Start("GExtension_Net_RunLua")
				net.WriteString(tosend)
			net.Send(self)
		end
	end
end