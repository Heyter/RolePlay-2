hook.Add("GExtensionInitialized", "GExtension_Import_GExtensionInitialized", function()
	concommand.Add("gex_import_ulib", function(ply)
		if IsValid(ply) and ply:GE_HasPermission("super") then
			if ULib and ULib.ucl then
				--Users
				if ULib.ucl.users then
					for steamid32, userdata in pairs(ULib.ucl.users) do
						local steamid64 = util.SteamIDTo64(steamid32)

						if steamid64 then
							if userdata["group"] != GExtension:GetSetting("settings_general_defaultgroup") then
								if GExtension.Players[steamid64] then
									GExtension:SetGroup(steamid64, userdata["group"], _, true)
									GExtension:Print('success', 'Imported player ' .. userdata["name"])
								else
									local data = {
										["steamid32"] = steamid32,
										["steamid64"] = steamid64,
										["nick"] = userdata["name"],
										["groups"] = {},
										["uniqueid"] = util.CRC('gm_' .. steamid32 .. '_gm')
									}

									GExtension:CreatePlayer(data["steamid64"], data["steamid32"], data["nick"], data["uniqueid"], function()
										GExtension.Players[steamid64] = data
										GExtension:SetGroup(steamid64, userdata["group"])
										GExtension:Print('success', 'Imported and created player ' .. data["nick"])
									end)
								end
							end
						end
					end
				end

				timer.Pause("GExtension_Bans_Refresh")

				--Bans
				if ULib.bans then
					for _, bandata in pairs(ULib.bans) do
						local steamid64 = util.SteamIDTo64(bandata["steamID"])

						if steamid64 then
							local steamid64_admin = string.Explode("STEAM", bandata["admin"])
							steamid64_admin = "STEAM" .. string.sub(steamid64_admin[2], 0, -2)

							local length = math.Round((bandata["unban"] - bandata["time"])/60)
							if tonumber(bandata["unban"]) == 0 then
								length = 0
							end

							local bans = GExtension:GetBans(steamid64)
							local duplicate = false

							for _, ban in pairs(bans) do
								if bandata["reason"] == ban["reason"] and length == ban["length"] and steamid64_admin == ban["steamid64_admin"] and bandata["time"] == ban["date_banned_unix"] then
									duplicate = true
								end
							end

							if not duplicate then
								GExtension:AddBan(steamid64, length, bandata["reason"], steamid64_admin, bandata["time"], function()
									GExtension:Print('success', 'Imported ban of player ' .. steamid64)
								end)
							else
								GExtension:Print('error', 'Ignored duplicate ban for ' .. steamid64)
							end
						end
					end
				end

				timer.Start("GExtension_Bans_Refresh")
			end
		else
			ply:GE_Error_Permissions()
		end
	end)

	concommand.Add("gex_import_serverguard", function(ply)
		if IsValid(ply) and ply:GE_HasPermission("super") then
			if serverguard then
				--Users
				local selectQuery = serverguard.mysql:Select("serverguard_users")
				selectQuery:Callback(function(data)
					if data then
						for _, userdata in pairs(data) do
							local steamid32 = userdata["steam_id"]
							local steamid64 = util.SteamIDTo64(steamid32)

							if steamid64 and steamid32 then
								if userdata["rank"] != GExtension:GetSetting("settings_general_defaultgroup") then
									if GExtension.Players[steamid64] then
										GExtension:SetGroup(steamid64, userdata["rank"], _, true)
										GExtension:Print('success', 'Imported player ' .. userdata["name"])
									else
										local data = {
											["steamid32"] = steamid32,
											["steamid64"] = steamid64,
											["nick"] = userdata["name"],
											["groups"] = {},
											["uniqueid"] = util.CRC('gm_' .. steamid32 .. '_gm')
										}

										GExtension:CreatePlayer(data["steamid64"], data["steamid32"], data["nick"], data["uniqueid"], function()
											GExtension.Players[steamid64] = data
											GExtension:SetGroup(steamid64, userdata["rank"])
											GExtension:Print('success', 'Imported and created player ' .. data["nick"])
										end)
									end
								end
							end
						end
					end
				end)
				selectQuery:Execute()

				--Bans
				local selectQuery = serverguard.mysql:Select("serverguard_bans")
				selectQuery:Callback(function(data)
					if data then
						for _, bandata in pairs(data) do
							local steamid64 = bandata["community_id"]

							if steamid64 then
								local length = math.Round((bandata["end_time"] - bandata["start_time"])/60)
								if tonumber(bandata["end_time"]) == 0 then
									length = 0
								end

								local bans = GExtension:GetBans(steamid64)
								local duplicate = false

								for _, ban in pairs(bans) do
									if bandata["reason"] == ban["reason"] and length == ban["length"] and bandata["start_time"] == ban["date_banned_unix"] then
										duplicate = true
									end
								end

								

								if not duplicate then
									GExtension:AddBan(steamid64, length, bandata["reason"], 0, bandata["start_time"], function()
										GExtension:Print('success', 'Imported ban of player ' .. steamid64)
									end)
								else
									GExtension:Print('error', 'Ignored duplicate ban for ' .. steamid64)
								end
							end
						end
					end
				end)
				selectQuery:Execute()
			end
		else
			ply:GE_Error_Permissions()
		end
	end)
end)