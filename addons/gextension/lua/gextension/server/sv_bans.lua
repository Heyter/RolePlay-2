//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

GExtension.Bans = GExtension.Bans or {}

function GExtension:GetBans(steamid64)
	local bans = {}

	for k, banData in pairs(self.Bans) do
		if banData["steamid64"] == steamid64 then
			bans[#bans+1] = banData
		end
	end

	return bans
end

function GExtension:IsBanned(steamid64)
	for k, banData in pairs(self.Bans) do
		if banData["steamid64"] == steamid64 then
			return true
		end
	end

	return false
end

function meta_ply:GE_IsBanned()
	return GExtension:IsBanned(self:SteamID64())
end

function meta_ply:GE_CanBan(steamid64_target, length)
	length = tonumber(length)

	if steamid64_target then
		if self:GE_HasPermission("bans_add") then
			if self:GE_CanTarget(steamid64_target) then
				local group_settings = self:GE_GetGroup()["settings"]
				local maxbanlength = 0

				if group_settings["maxbanlength"] then
					maxbanlength = tonumber(group_settings["maxbanlength"])
				end

				if ((length <= maxbanlength and length > 0) or (maxbanlength == 0)) and length >= 0 then
					return true
				end
			end
		end
	end

	return false
end

function GExtension:GetBanData(steamid64)
	for k, banData in pairs(self.Bans) do
		if banData["steamid64"] == steamid64 then
			return banData
		end
	end
end

function GExtension:Ban(steamid64, length, reason, steamid64_admin)
	steamid64_admin = steamid64_admin or 0
	length = tonumber(length)

	if length >= 0 then
		GExtension:AddBan(steamid64, length, reason, steamid64_admin, self:CurrentTime(), function()
			local nick_victim = steamid64
			local nick_admin = steamid64_admin

			local userdata_victim = self:GetUserData(steamid64)
			local userdata_admin = self:GetUserData(steamid64_admin)

			if userdata_victim then
				nick_victim = userdata_victim["nick"]
			end

			if userdata_admin then
				nick_admin = userdata_admin["nick"]
			end

			if length == 0 then
				self:Print("neutral", nick_admin .. " (" .. steamid64_admin .. ") banned " .. nick_victim .. " (" .. steamid64 .. ") permanently. Reason: '" .. reason .. "'")
				self:PrintToChat(self:FormatString(GExtension:Lang('player_banned_perma'), {nick_victim, nick_admin, reason}))
			else
				self:Print("neutral", nick_admin .. " (" .. steamid64_admin .. ") banned " .. nick_victim .. " (" .. steamid64 .. ") for " .. length .. " minutes. Reason:  '" .. reason .. "'")
				self:PrintToChat(self:FormatString(GExtension:Lang('player_banned'), {nick_victim, length, nick_admin, reason}))
			end

			GExtension:InitBans()
		end)
	end 
end

function GExtension:Unban(steamid64, steamid64_admin)
	self:Query("UPDATE gex_bans SET status = 1, steamid64_admin_unbanned = %2%, date_unbanned = NOW() WHERE status = 0 AND steamid64 = %1% AND (serverbundle = %3% OR global = 1);", {steamid64, steamid64_admin, self.Bundle}, function()
		local nick_victim = steamid64
		local nick_admin = steamid64_admin

		local userdata_victim = self:GetUserData(steamid64)
		local userdata_admin = self:GetUserData(steamid64_admin)

		if userdata_victim then
			nick_victim = userdata_victim["nick"]
		end

		if userdata_admin then
			nick_admin = userdata_admin["nick"]
		end

		self:Print("neutral", nick_admin .. " (" .. steamid64_admin .. ") unbanned " .. nick_victim .. " (" .. steamid64 .. ")")
		self:PrintToChat(self:FormatString(GExtension:Lang('player_unbanned'), {nick_victim, nick_admin}))

		GExtension:InitBans()
	end)
end

function GExtension:AddBan(steamid64, length, reason, steamid64_admin, time, callback)
	steamid64_admin = steamid64_admin or 0
	length = tonumber(length)

	if length >= 0 then
		self:Query("INSERT INTO gex_bans (steamid64, reason, serverbundle, length, steamid64_admin, date_banned, steamid64_admin_unbanned, status, global) VALUES(%1%, %2%, %3%, %4%, %5%, FROM_UNIXTIME(%6%), '', 0, 0)", {steamid64, reason, self.Bundle, length, steamid64_admin, time}, function()
			if callback then
				callback()
			end
		end)
	end 
end

function meta_ply:GE_Ban(length, reason, steamid64_admin)
	GExtension:Ban(self:SteamID64(), length, reason, steamid64_admin)
end

function GExtension:InitBans()
	GExtension:Query("SELECT *, UNIX_TIMESTAMP(date_banned) AS date_banned_unix FROM gex_bans WHERE status = 0 AND ((date_banned + INTERVAL length MINUTE) > NOW() OR length = 0) AND (serverbundle = %1% OR global = 1);", {GExtension.Bundle}, function(data)
		GExtension.Bans = data

		for k, ply in pairs(player.GetHumans()) do
			if ply:GE_IsBanned() then
				local group_settings = ply:GE_GetGroup()["settings"]
				local immune = false

				if group_settings["kickbanimmunity"] then
					immune = tobool(group_settings["kickbanimmunity"])
				end

				if not immune then
					ply:Kick("You are banned from the server.")
					--ply:Kick("\n\n" .. self:CreateBanMessage(self:GetBanData(ply:SteamID64())) )
				else
					ply:GE_PrintToChat(self:Lang("player_kickban_immune"))
				end
			end
		end
	end)
end

function GExtension:CreateBanMessage(banData)
	local admin_nick = banData["steamid64_admin"]
	local admin_userdata = self:GetUserData(banData["steamid64_admin"])

	local unban = GExtension:FormatDate(tonumber(banData["date_banned_unix"]) + tonumber(banData["length"]) * 60)

	if banData["length"] <= 0 then
		unban = self:Lang("never")
	end

	if admin_userdata then
		admin_nick = admin_userdata["nick"]
	end

	return "                            > Ban Message <\n\n" .. self:Lang("reason") .. ": " .. banData["reason"] .. "\n" .. self:Lang("ban_date") .. ": " .. GExtension:FormatDate(tonumber(banData["date_banned_unix"])) .. "\n" .. self:Lang("unban_date") .. ": " .. unban .. "\nAdmin: " .. admin_nick .. "\n" .. self:Lang("unban_url") .. ": " .. GExtension.WebURL .. "\n"
end

if not GExtension.Initialized then
	hook.Add("PlayerInitialSpawn", "GExtension_Bans_PlayerInitialSpawn_Temp", function(ply)
		timer.Simple(10, function()
			if IsValid(ply) then
				if not GExtension.Initialized then
					ply:GE_PrintToChat('<green>GExtension</green> is not initialized. Please contact an admin. Check out the console for errors.')
				end
			end
		end)
	end)
end

hook.Add("GExtensionInitialized", "GExtension_Bans_GExtensionInitialized", function()
	hook.Remove("PlayerInitialSpawn", "GExtension_Bans_PlayerInitialSpawn_Temp")

	hook.Add("CheckPassword", "GExtension_Bans_CheckPassword", function(steamid64, ip)
		if GExtension:IsBanned(steamid64) then
			local banData = GExtension:GetBanData(steamid64)

			local group_settings = GExtension:GetGroup(steamid64)["settings"]
			local immune = false

			if group_settings["kickbanimmunity"] then
				immune = tobool(group_settings["kickbanimmunity"])
			end

			if not immune then
				GExtension:Print("neutral", steamid64 .. " tried to connect with ip " .. ip .. ", but is banned.")
				return false, GExtension:CreateBanMessage(banData)
			end
		end
	end)

	GExtension:InitBans()

	timer.Create("GExtension_Bans_Refresh", 60, 0, function()
		GExtension:InitBans()
	end)

	function meta_ply:Ban(length, kick, reason)
		GExtension:Ban(self:SteamID64(), length, reason, 0)
	end

	if ULib then
		ULib.kickban = function(ply, length, reason, admin)
			if IsValid(ply) then
				if IsValid(admin) then
					if admin:GE_CanBan(ply:SteamID64(), length) then
						GExtension:Ban(ply:SteamID64(), length, reason, admin:SteamID64())
					else
						admin:GE_Error_Permissions()
					end
				else
					GExtension:Ban(ply:SteamID64(), length, reason, 0)
				end
			end
		end

		ULib.ban = function(ply, length, reason, admin)
			if IsValid(ply) then
				if IsValid(admin) then
					if admin:GE_CanBan(ply:SteamID64(), length) then
						GExtension:Ban(ply:SteamID64(), length, reason, admin:SteamID64())
					else
						admin:GE_Error_Permissions()
					end
				else
					GExtension:Ban(ply:SteamID64(), length, reason, 0)
				end
			end
		end

		ULib.addBan = function(steamid32, length, reason, nick, admin)
			local steamid64 = util.SteamIDTo64(steamid32)

			if not steamid64 then return end

			if IsValid(admin) then
				if admin:GE_CanBan(steamid64, length) then
					GExtension:Ban(steamid64, length, reason, admin:SteamID64())
				else
					admin:GE_Error_Permissions()
				end
			else
				GExtension:Ban(steamid64, length, reason, 0)
			end
		end

		local ulx_unban = ULib.unban

		ULib.unban = function(steamid32, steamid32_admin)
			local steamid64 = util.SteamIDTo64(steamid32)
			local steamid64_admin = "0"

			if steamid32_admin then
				util.SteamIDTo64(steamid32)
			end

			if steamid64 and steamid64_admin then
				if steamid64_admin == "0" then
					GExtension:Unban(steamid64, steamid64_admin)
				else
					local ply = player.GetBySteamID64(steamid64_admin)

					if IsValid(ply) then
						if ply:GE_CanBan(steamid64, 1) then
							GExtension:Unban(steamid64, steamid64_admin)
						else
							ply:GE_Error_Permissions()
						end
					else
						GExtension:Print("error", "Tried to unban " .. steamid64 .. " from invalid player.")
					end
				end
			end

			ulx_unban(steamid32, steamid32_admin)
		end
	end

	if evolve then
		function evolve:Ban(ply, length, reason)
			GExtension:Ban(ply:SteamID64(), length, reason, 0)
		end
	end

	if serverguard then
		function serverguard:BanPlayer(admin, ply_obj, length, reason)
			if ply_obj then
				local steamid64 = nil;

				if type(ply_obj) == "Player" then
					steamid64 = ply_obj:SteamID64()
				elseif type(ply_obj) == "string" then
					local target = GExtension:GetPlayerByNick(ply_obj)

					if IsValid(target) then
						ply_obj = target

						steamid64 = ply_obj:SteamID64()
					elseif string.find(ply_obj, "STEAM_(%d+):(%d+):(%d+)") then
						steamid64 = util.SteamIDTo64(ply_obj)
					end
				end

				if IsValid(admin) then
					if admin:GE_CanBan(steamid64, length) then
						GExtension:Ban(steamid64, length, reason, admin:SteamID64())
					else
						admin:GE_Error_Permissions()
					end
				else
					GExtension:Ban(steamid64, length, reason, 0)
				end
			end
		end

		local servergaurd_unban = serverguard["UnbanPlayer"]

		function serverguard:UnbanPlayer(steamid32, admin)
			local steamid64_admin = "0"
			local steamid64 = util.SteamIDTo64(steamid32)

			if IsValid(admin) then
				steamid64_admin = admin:SteamID64()
			end

			if steamid64 and steamid64_admin then
				if steamid64_admin == "0" then
					GExtension:Unban(steamid64, steamid64_admin)
				else
					if IsValid(admin) then
						if admin:GE_CanBan(steamid64, 1) then
							GExtension:Unban(steamid64, steamid64_admin)
						else
							admin:GE_Error_Permissions()
						end
					else
						GExtension:Print("error", "Tried to unban " .. steamid64 .. " from invalid player.")
					end
				end
			end

			servergaurd_unban(self, steamid32, admin)
		end

		concommand.Add("serverguard_addmban", function(ply, _, args)
			if (serverguard.player:HasPermission(ply, "Ban")) then
				local steamid32 	= string.Trim(args[1]) 
				local steamid64 	= util.SteamIDTo64(steamid32)
				local length 		= tonumber(args[2]);
				local reason 		= table.concat(args, " ", 4) or ""
				local steamid64_admin 	= ply:SteamID64()

				if ply:GE_CanBan(steamid64, length) then
					GExtension:Ban(steamid64, length, reason, steamid64_admin)
				else
					admin:GE_Error_Permissions()
				end
			end
		end)

		concommand.Add("serverguard_unban", function(ply, _, args)
			if (util.IsConsole(ply)) then
				local steamID = args[1]

				if (serverguard.banTable[steamID]) then
					serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, "Console", SERVERGUARD.NOTIFY.WHITE, " has unbanned ", SERVERGUARD.NOTIFY.RED, serverguard.banTable[steamID].player, SERVERGUARD.NOTIFY.WHITE, ".")
				end	

				serverguard:UnbanPlayer(steamID)
			else
				if (serverguard.player:HasPermission(ply, "Unban")) then
					local steamID = args[1]
					
					if (serverguard.banTable[steamID]) then
						serverguard.Notify(nil, SERVERGUARD.NOTIFY.GREEN, serverguard.player:GetName(ply), SERVERGUARD.NOTIFY.WHITE, " has unbanned ", SERVERGUARD.NOTIFY.RED, serverguard.banTable[steamID].player, SERVERGUARD.NOTIFY.WHITE, ".")
					end
						
					serverguard:UnbanPlayer(steamID, ply)
				end
			end
		end)

		local command = {}

		command.help				= "Unban a player."
		command.command 			= "unban"
		command.arguments 			= {"steamid"}
		command.permissions 		= {"Unban"}

		function command:Execute(player, silent, arguments)
			local steamID = arguments[1]
			
			if (serverguard.banTable[steamID]) then
				if (!silent) then
					serverguard.Notify(nil, SGPF("command_unban", serverguard.player:GetName(player), serverguard.banTable[steamID].player))
				end
			end

			serverguard:UnbanPlayer(steamID, player)
		end

		serverguard.command:Add(command)
	end

	if not ULib and not evolve and not serverguard then
		GExtension:RegisterChatCommand("!ban", function(ply, args)
			if not args[1] or not args[2] or not args[3] then return end

			local reason = GExtension:ConcatArgs(args, 3)

			local target = GExtension:GetPlayerByNick(args[1])

			if IsValid(target) and isnumber(args[2]) then
				if ply:GE_CanBan(target:SteamID64(), args[2]) then
					target:GE_Ban(length, reason, ply:SteamID64())
				end
			end
		end)
	end

	GExtension:RegisterChatCommand("!bans", function(ply)
		ply:SendLua([[gui.OpenURL("]] .. GExtension.WebURL .. [[?t=admin_bans")]])
	end)

	concommand.Add("gex_ban", function(ply, _, args)
		if not args[1] or not args[2] or not args[3] then return end
		
		if GExtension:IsConsole(ply) then
			GExtension:Ban(args[1], args[2], args[3], 0)
		elseif IsValid(ply) then
			if ply:GE_CanBan(args[1], args[2]) then
				GExtension:Ban(args[1], args[2], args[3], ply:SteamID64())
			else
				ply:GE_Error_Permissions()
			end
		end
	end)

	concommand.Add("gex_unban", function(ply, _, args)
		if not args[1] then return end
		
		if GExtension:IsConsole(ply) then
			GExtension:Unban(args[1], 0)
		elseif IsValid(ply) then
			if ply:GE_CanBan(args[1], 1) then
				GExtension:Unban(args[1], ply:SteamID64())
			else
				ply:GE_Error_Permissions()
			end
		end
	end)
end)