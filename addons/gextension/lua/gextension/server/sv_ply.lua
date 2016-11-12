//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

util.AddNetworkString("GExtension_Net_RefreshSteamData")

function GExtension:InitPlayer(ply, second, callback)
	if IsValid(ply) and not ply:IsBot() then
		self:Query("SELECT * FROM gex_users WHERE steamid64 = %1%;", {ply:SteamID64()}, function(data)
			if IsValid(ply) and not ply:IsBot() then
				if table.Count(data) == 1 then
					data = data[1]

					data["ips"] = self:FromJson(data["ips"])
					data["groups"] = self:FromJson(data["groups"])
					data["nick"] = self:HTMLSpecialChars(data["nick"])

					local ip = string.Explode(":", ply:IPAddress())[1]

					if !table.HasValue(data["ips"], ip) then
						table.insert(data["ips"], 0, ip)
					end

					self.Players[ply:SteamID64()] = data

					self:Query("UPDATE gex_users SET date_lastonline_gmod = NOW(), ips = %1%, nick = %2% WHERE steamid64 = %3%;", {util.TableToJSON(data["ips"]), ply:Nick(), ply:SteamID64()})

					ply:GE_CheckGroup()

					local group_settings = ply:GE_GetGroup()["settings"]

					if group_settings["reservedslot"] then
						if tobool(group_settings["reservedslot"]) then
							if not table.HasValue(self.ReservedSlotPlayers, ply:SteamID64()) then
								self.ReservedSlotPlayers[#self.ReservedSlotPlayers+1] = ply:SteamID64()
							end
						end
					end

					if group_settings["ttt_specprop"] then
						if tobool(group_settings["ttt_specprop"]) then
							if not table.HasValue(self.SpecPropPlayers, ply:SteamID64()) then
								self.SpecPropPlayers[#self.SpecPropPlayers+1] = ply:SteamID64()
							end
						end
					end

					if group_settings["ttt_voicedrain"] then
						if tobool(group_settings["ttt_voicedrain"]) then
							net.Start("GExtension_Net_RunLua")
								net.WriteString([[GExtension.Voicedrain = true]])
							net.Send(ply)
						end
					end

					self:Print("success", "Player authed: " .. ply:Nick())

					timer.Create("GExtension_Player_Refresh_" .. ply:SteamID64(), 300, 0, function()
						GExtension:RefreshPlayer(ply)
					end)

					net.Start("GExtension_Net_RefreshSteamData")
					net.Send(ply)

					hook.Call("GExtensionPlayerInitialized", _, ply)
				else
					self:CreatePlayer(ply:SteamID64(), ply:SteamID(), ply:Nick(), ply:UniqueID(), function()
						if !second then
							self:InitPlayer(ply, true)
						else
							--Ersetzen mit eigener funktion
							ply:Kick("Authentification failed")
						end
					end)
				end

				if callback then
					callback()
				end
			end
		end)
	end
end

function GExtension:RefreshPlayer(ply, callback)
	if IsValid(ply) and not ply:IsBot() then
		self:Query("SELECT * FROM gex_users WHERE steamid64 = %1%;", {ply:SteamID64()}, function(data)
			if IsValid(ply) then
				if table.Count(data) == 1 then
					data = data[1]

					data["ips"] = self:FromJson(data["ips"])
					data["groups"] = self:FromJson(data["groups"])
					data["nick"] = self:HTMLSpecialChars(data["nick"])

					self.Players[ply:SteamID64()] = data

					ply:GE_CheckGroup()
				end

				if callback then
					callback()
				end
			end
		end)
	end
end

function GExtension:CreatePlayer(steamid64, steamid32, nick, uniqueid, callback)
	self:Query("INSERT IGNORE INTO gex_users (steamid64, steamid32, uniqueid, nick, random, groups, avatar_small, avatar_medium, avatar_large, ips, ts3uid, emailnotifications, email, language) VALUES(%1%, %2%, %3%, %4%, %5%, '', '', '', '', '', '', 1, '', '');", {steamid64, steamid32, uniqueid, self:HTMLSpecialChars(nick),  GExtension:RandomString(25)}, function()
		if callback then
			callback()
		end
	end)
end

function GExtension:InitPlayers(callback)
	self:Query("SELECT * FROM gex_users", _, function(data)
		for _, plydata in pairs(data) do
			plydata["ips"] = self:FromJson(plydata["ips"])
			plydata["groups"] = self:FromJson(plydata["groups"])

			plydata["nick"] = self:HTMLSpecialChars(plydata["nick"])

			self.Players[plydata["steamid64"]] = plydata
		end

		if callback then
			callback()
		end
	end)
end

hook.Add("GExtensionInitialized", "GExtension_Players_GExtensionInitialized", function()
	hook.Add("GExtensionPlayerConnected","GExtension_Players_GExtensionPlayerConnected", function(ply)
		GExtension:InitPlayer(ply)
	end)

	hook.Add("PlayerDisconnected", "GExtension_Player_PlayerDisconnected", function(ply)
		timer.Remove("GExtension_Player_Refresh_" .. ply:SteamID64())
	end)

	if GExtension.ClearULibUsers and ULib then
		hook.Add("ShutDown", "GExtension_Players_ShutDown", function()
			file.Write("ulib/users.txt", "")
		end)
	end

	GExtension:RegisterChatCommand("!profile", function(ply, args)
		if not args[1] then return end

		local target = GExtension:GetPlayerByNick(args[1])

		if IsValid(target) then
			ply:SendLua([[gui.OpenURL("]] .. GExtension.WebURL .. [[?t=user&id=]] .. target:SteamID64() .. [[")]])
		end
	end)
end)

hook.Add("PlayerInitialSpawn","GExtension_Players_PlayerInitialSpawn", function(ply)
	if GExtension.Initialized then
		hook.Call("GExtensionPlayerConnected", _, ply)
	else
		GExtension.ConnectQueue[#GExtension.ConnectQueue+1] = ply
	end
end)

function meta_ply:GE_GetUserData()
	return GExtension:GetUserData(self:SteamID64())
end

function GExtension:GetUserData(steamid64)
	steamid64 = tostring(steamid64)
	
	if GExtension.Players[steamid64] then
		return GExtension.Players[steamid64]
	else
		local ply = player.GetBySteamID64(steamid64)

		if IsValid(ply) then
			GExtension:Print("error", "Player " .. ply:Nick() .. " not found in local data, refreshing...")
			GExtension:InitPlayer(ply)
			return false
		else
			GExtension:Print("error", steamid64 .. " not found in local data.")
			return false
		end
	end
end

function GExtension:SetUserData(steamid64, key, value)
	local keys_allowed = {"groups"}

	if table.HasValue(keys_allowed, key) then
		self:Query("UPDATE gex_users SET " .. key .. " = %1% WHERE steamid64 = %2%;", {value, steamid64})
	end
end