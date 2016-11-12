//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

util.AddNetworkString("GExtension_Net_WarningsPanelShow")
util.AddNetworkString("GExtension_Net_WarningsData")

function GExtension:InitWarnings(callback)
	self:Query("SELECT steamid64, steamid64_admin, id, status, reason, UNIX_TIMESTAMP(date) AS date_unix FROM gex_warnings WHERE status <> 2 AND serverbundle = %1%", {self.Bundle}, function(data)
		self.Warnings = {}

		for _, ply in pairs(player.GetHumans()) do
			self.Warnings[ply:SteamID64()] = {}
		end

		for _, warning in pairs(data) do
			if not table.HasValue(table.GetKeys(self.Warnings), warning["steamid64"]) then
				self.Warnings[warning["steamid64"]] = {}
			end

			local userdata = self:GetUserData(warning["steamid64"])
			local userdata_admin = self:GetUserData(warning["steamid64_admin"])

			if userdata and userdata_admin then
				warning["nick_admin"] = self:RemoveQuotes(userdata_admin["nick"])
				warning["nick"] = self:RemoveQuotes(userdata["nick"])
				warning["date_f"] = self:FormatDate(warning["date_unix"])
				warning["active"] = true
				warning["reason"] = self:HTMLSpecialChars(self:RemoveQuotes(warning["reason"]))

				if tobool(warning["status"]) or (self:CurrentTime() > (tonumber(warning["date_unix"]) + (tonumber(self:GetSetting("settings_warnings_decay")) * 60) )) then
					warning["active"] = false
				end

				self.Warnings[tostring(warning["steamid64"])][warning["id"]] = warning
			else
				GExtension:Query("UPDATE gex_warnings SET status = 2 WHERE id = %1%;", {warning["id"]})
			end
		end

		if callback then
			callback()
		end
	end)
end

hook.Add("GExtensionInitialized", "GExtension_Warnings_GExtensionInitialized", function()
	GExtension:InitWarnings()

	GExtension:RegisterChatCommand("!warnings", function(ply)
		net.Start("GExtension_Net_WarningsPanelShow")
 		net.Send(ply)
	end)

	GExtension:RegisterChatCommand("!warn", function(ply, args)
		if not ply:GE_HasPermission("warnings_add") then return end
		if not args[1] or not args[2] then return end

		local reason = GExtension:ConcatArgs(args, 2)

		local target = GExtension:GetPlayerByNick(args[1])

		if target and IsValid(target) then
			local nickparts = string.Explode(' ', target:Nick())

			if #nickparts > 1 then
				nickparts = GExtension:ConcatArgs(nickparts, 2) .. ' '
				reason = string.Replace(reason,nickparts,'')
			end

			GExtension:Warn(target:SteamID64(), reason, ply:SteamID64())

			return false;
		end
	end)

	hook.Add("GExtensionPlayerInitialized", "GExtension_Warnings_GExtensionPlayerInitialized", function(ply)
		if GExtension.Warnings[ply:SteamID64()] and istable(GExtension.Warnings[ply:SteamID64()]) then
			local warncount = ply:GE_GetActiveWarnings()

			if tobool(warncount) then
				GExtension:AddToConnectMessage(ply, GExtension:FormatString(GExtension:Lang('player_warnings_active'), {warncount}))
			end
		end
	end)
end)

function meta_ply:GE_GetActiveWarnings()
	local warncount = 0

	for _, warning in pairs(GExtension.Warnings[self:SteamID64()]) do
		if tobool(warning["active"]) then
			warncount = warncount + 1
		end
	end

	return warncount
end

function GExtension:SendWarnings(ply, second)
	if self.Warnings[ply:SteamID64()] then
		local warnings = self.Warnings[ply:SteamID64()]
		local admin = {}
		local settings = {}
		local players = {}

		for _, ply in pairs(player.GetHumans()) do
			players[ply:SteamID64()] = ply
		end

		if ply:GE_HasPermission("warnings_add") then
			for steamid64, warns in pairs(self.Warnings) do
				if players[steamid64] then
					admin[steamid64] = warns
				end
			end
		end

		if ply:GE_HasPermission("settings_warnings") then
			settings["settings_warnings_kick"] = self:GetSetting("settings_warnings_kick")
			settings["settings_warnings_ban"] = self:GetSetting("settings_warnings_ban")
			settings["settings_warnings_kick_threshold"] = self:GetSetting("settings_warnings_kick_threshold")
			settings["settings_warnings_ban_threshold"] = self:GetSetting("settings_warnings_ban_threshold")
			settings["settings_warnings_decay"] = self:GetSetting("settings_warnings_decay")
			settings["settings_warnings_ban_length"] = self:GetSetting("settings_warnings_ban_length")
		end

		local data_warnings = util.Compress(pon.encode(warnings))
		local data_admin = util.Compress(pon.encode(admin))
		local data_settings = util.Compress(pon.encode(settings))

		net.Start("GExtension_Net_WarningsData")
			net.WriteUInt(#data_warnings, 16)
			net.WriteData(data_warnings, #data_warnings)
			net.WriteUInt(#data_admin, 16)
			net.WriteData(data_admin, #data_admin)
			net.WriteUInt(#data_settings, 16)
			net.WriteData(data_settings, #data_settings)
	 	net.Send(ply)
	else
		self:InitWarnings(function()
			if not second then
				self:SendWarnings(ply, true)
			end
		end)
	end
end

function GExtension:Warn(steamid64, reason, steamid64_admin, callback)
	reason = self:HTMLSpecialChars(reason)

	steamid64_admin = steamid64_admin or 0

	if isstring(reason) and string.Trim(reason) != "" then
		local ply = player.GetBySteamID64(steamid64)

		self:Query("INSERT INTO gex_warnings (steamid64, steamid64_admin, reason, serverbundle, status) VALUES(%1%, %2%, %3%, %4%, 0);", {steamid64, steamid64_admin, reason, self.Bundle}, function()
			self:InitWarnings(function()
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

				self:Print("neutral", nick_admin .. " (" .. steamid64_admin .. ") warned " .. nick_victim .. " (" .. steamid64 .. ") for '" .. reason .. "'")
				self:PrintToChat(self:FormatString(GExtension:Lang('player_warned'), {nick_victim, nick_admin, reason}), steamid64)

				if IsValid(ply) then
					ply:GE_PrintToChat(self:FormatString(self:Lang('you_warned'), {nick_admin, reason}))
					ply:GE_PrintToChat(self:FormatString(self:Lang('player_warnings_active'), {ply:GE_GetActiveWarnings()}))
					ply:SendLua([[sound.PlayURL ( "https://www.dropbox.com/s/q8dget89wvdcyog/negativebeep.wav?dl=1", "", function() end)]])
				end

				self:InitWarnings(function()
					local warncount = 1

					if table.HasValue(table.GetKeys(self.Warnings), steamid64) then
						warncount = 0

						for _, warning in pairs(self.Warnings[steamid64]) do
							if tobool(warning["active"]) then
								warncount = warncount + 1
							end
						end
					end

					local ban_threshold = tonumber(self:GetSetting("settings_warnings_ban_threshold"))
					local kick_threshold = tonumber(self:GetSetting("settings_warnings_kick_threshold"))

					if tobool(self:GetSetting("settings_warnings_ban")) && isnumber(ban_threshold) && warncount >= ban_threshold then
						self:Ban(steamid64, tonumber(self:GetSetting("settings_warnings_ban_length")), '[Warn] ' .. reason, steamid64_admin)
					elseif tobool(self:GetSetting("settings_warnings_kick")) && isnumber(kick_threshold) && warncount >= kick_threshold then
						if IsValid(ply) then
							ply:Kick("\n\n                            > Kick Message <\n\n" .. self:Lang("reason") .. ": " .. self:Lang("threshold_limit_reached") .. "\n\n" .. self:Lang("warning") .. ": " .. reason .." \n")
						end
					end

					if callback then
						callback()
					end
				end)
			end)
		end)
	end
end

concommand.Add("gex_warnings", function(ply)
 	net.Start("GExtension_Net_WarningsPanelShow")
 	net.Send(ply)
end)

concommand.Add("gex_warnings_panel_loaded", function(ply)
 	GExtension:InitWarnings(function()
 		GExtension:SendWarnings(ply)
 	end)
end)

concommand.Add("gex_warnings_inactive", function(ply, _, args)
	if not args[1] then return end

	if IsValid(ply) then
		if ply:GE_HasPermission("warnings_add") then
			GExtension:Query("UPDATE gex_warnings SET status = 1 WHERE id = %1%", {tonumber(args[1])}, function()
				GExtension:InitWarnings(function()
			 		GExtension:SendWarnings(ply)
			 	end)
			end)
 		end
	end
end)

concommand.Add("gex_warnings_delete", function(ply, _, args)
 	if not args[1] then return end
	
	if IsValid(ply) then
		if ply:GE_HasPermission("warnings_delete") then
			GExtension:Query("UPDATE gex_warnings SET status = 2 WHERE id = %1%", {tonumber(args[1])}, function()
				GExtension:InitWarnings(function()
			 		GExtension:SendWarnings(ply)
			 	end)
			end)
 		end
	end
end)

concommand.Add("gex_settings_warnings", function(ply, _, args)
	if not args[1] or not args[2] or not args[3] or not args[4] or not args[5] or not args[6] then return end

	if IsValid(ply) then
		if ply:GE_HasPermission("settings_warnings") then
			local finished = 0

			function CheckForFinished()
				finished = finished + 1;

				if finished == 6 then
					GExtension:InitWarnings(function()
				 		GExtension:SendWarnings(ply)
				 	end)
				end
			end

			GExtension:SetSetting("settings_warnings_kick", tonumber(args[1]), function() CheckForFinished() end)
			GExtension:SetSetting("settings_warnings_ban", tonumber(args[2]), function() CheckForFinished() end)
			GExtension:SetSetting("settings_warnings_kick_threshold", tonumber(args[3]), function() CheckForFinished() end)
			GExtension:SetSetting("settings_warnings_ban_threshold", tonumber(args[4]), function() CheckForFinished() end)
			GExtension:SetSetting("settings_warnings_decay", tonumber(args[5]), function() CheckForFinished() end)
			GExtension:SetSetting("settings_warnings_ban_length", tonumber(args[6]), function() CheckForFinished() end)
 		end
	end
end)

concommand.Add("gex_warn", function(ply, _, args)
	if not args[1] or not args[2] then return end

 	if GExtension:IsConsole(ply) then
		GExtension:Warn(args[1], args[2], 0)
	elseif IsValid(ply) then
		if ply:GE_HasPermission("warnings_add") then
			GExtension:Warn(args[1], args[2], ply:SteamID64(), function()
				GExtension:SendWarnings(ply)
			end)
		end
	end
end)
