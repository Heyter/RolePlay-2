//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

--checks if expireDate is expired
function GExtension:IsExpired(expireDate)
	local currentTime = self:CurrentTime()
	if expireDate - currentTime > 0 then
		return false
	else
		return true
	end
end

function GExtension:SetExecutedOn(rewardData)
	if !rewardData then return end

	local executed_on = self:FromJson(rewardData["executed_on"])

	if !table.HasValue(executed_on,self.ServerID) then
		executed_on[#executed_on+1] = GExtension.ServerID
		executed_on = util.TableToJSON(executed_on)

		self.Rewards[rewardData["id"]]["executed_on"] = executed_on

		self:Query("UPDATE gex_rewards SET executed_on = %1% WHERE id = %2%;", {executed_on, rewardData["id"]})
	end
end

function GExtension:SetExecuted(rewardData)
	if !rewardData then return end

	self.Rewards[rewardData["id"]]["status"] = 1

	self:Query("UPDATE gex_rewards SET status = 1 WHERE id = %1%;", {rewardData["id"]})
end


--executes a reward
function GExtension:ExecuteReward(ply, rewardData, setExecuted)
	if !IsValid(ply) or !rewardData then return end

	local executed = false;

	local package_bought = nil 

	if self.BoughtPackages[rewardData["steamid64"]] then
		if self.BoughtPackages[rewardData["steamid64"]][rewardData["donationid"]] then
			package_bought = self.BoughtPackages[rewardData["steamid64"]][rewardData["donationid"]]
		end
	end

	local donation = self.Donations[rewardData["donationid"]]

	if package_bought then
		if rewardData["type"] == "ps1_points" then
			if PS then
				ply:PS_GivePoints(tonumber(rewardData["value"]))
				executed = true
			end
		elseif rewardData["type"] == "ps2_points" then
			if Pointshop2 then
				ply:PS2_AddStandardPoints(tonumber(rewardData["value"]))
				executed = true
			end
		elseif rewardData["type"] == "ps2_premiumpoints" then
			if Pointshop2 then
				ply:PS2_AddPremiumPoints(tonumber(rewardData["value"]))
				executed = true
			end
		elseif rewardData["type"] == "darkrp_money" then
			if DarkRP then
				ply:addMoney(tonumber(rewardData["value"]))
				executed = true
			end
		elseif rewardData["type"] == "darkrp_levels" then
			if DarkRP and ply:getDarkRPVar("level") != nil then
				ply:addLevels(tonumber(rewardData["value"]))
				executed = true
			end
		elseif rewardData["type"] == "dayz_credits" then
			if DayZ then
				ply:GiveCredits(tonumber(rewardData["value"]))
				executed = true
			end
		elseif rewardData["type"] == "ttt_specprop" then
			if not table.HasValue(self.SpecPropPlayers, ply:SteamID64()) then
				self.SpecPropPlayers[#self.SpecPropPlayers+1] = ply:SteamID64()
			end

			executed = true
		elseif rewardData["type"] == "ttt_voicedrain" then
			net.Start("GExtension_Net_RunLua")
				net.WriteString([[GExtension.Voicedrain = true]])
			net.Send(ply)

			executed = true
		elseif rewardData["type"] == "reservedslot" then
			if not table.HasValue(self.ReservedSlotPlayers, ply:SteamID64()) then
				self.ReservedSlotPlayers[#self.ReservedSlotPlayers+1] = ply:SteamID64()
			end

			executed = true
		elseif rewardData["type"] == "dayz_items" then
			if DayZ then
				local items = self:FromJson(rewardData["value"])
				if items then
					for k, v in pairs(items) do
						ply:GiveItem(v, 1)
					end
				end

				executed = true
			end
		elseif rewardData["type"] == "lua" then
			local luaString = rewardData["value"]

			local amount = 0

			if donation then
				amount = donation["amount"]
			end

			local replacements = {["package_id"] = rewardData["package"], ["package_name"] = package_bought["package_name"], ["amount_donated"] = amount}

			for k, v in pairs(replacements) do
				luaString = string.Replace(tostring(luaString), "%" .. tostring(k) .. "%", tostring(v))
			end

			if not GExtension.Players.RewardPlayers then GExtension.Players.RewardPlayers = {} end

			GExtension.Players.RewardPlayers[rewardData["id"]] = ply
			RunString("local PLAYER = GExtension.Players.RewardPlayers[" .. rewardData["id"] .. "] " .. luaString, "GExtension_Rewards_Lua")

			executed = true
		elseif rewardData["type"] == "concommands" then
			local concommands = self:FromJson(rewardData["value"])

			local amount = 0

			if donation then
				amount = donation["amount"]
			end

			local replacements = {["nick"] = ply:Nick(), ["steamid64"] = ply:SteamID64(), ["steamid32"] = ply:SteamID(), ["uniqueid"] = ply:UniqueID(), ["amount_donated"] = amount, ["package_id"] = rewardData["package"], ["package_name"] = package_bought["package_name"]}

			for _, cc in pairs(concommands) do
				for k, v in pairs(replacements) do
					cc = string.Replace(tostring(cc), "%" .. tostring(k) .. "%", tostring(v))
				end

				game.ConsoleCommand(cc .. "\n")
			end

			executed = true
		elseif rewardData["type"] == "weapons" then
			local weaponsToGive = self:FromJson(rewardData["value"])

			for _, weapon in pairs(weaponsToGive) do
				ply:Give(weapon)
			end

			executed = true
		end
	end
	
	if executed then
		self:SetExecutedOn(rewardData)

		if self.PrintExecutedRewards then
			self:Print("neutral", "[Reward Executed] Type: " .. rewardData["type"] .. ", Value: " .. rewardData["value"])
		end

		if setExecuted then
			self:SetExecuted(rewardData)
		end
	end
end

function GExtension:RefreshRewards(callback)
	GExtension:Query("SELECT *, UNIX_TIMESTAMP(expires) AS expires_unix FROM gex_rewards WHERE status = 0 AND serverbundle = %1% ORDER BY on_expire ASC;", {GExtension.Bundle}, function(data)
		self.Rewards = {}

		for k,v in pairs(data) do
			self.Rewards[v['id']] = v
		end

		GExtension:InitBoughtPackages(function()
			GExtension:InitDonations(function()
				if callback then
					callback()
				end
			end)
		end)
	end)
end

--checks all rewards whether some of them should get executed
--MODE:
--0: direct/on_expire, 1: on_connect, 2: on_spawn
function GExtension:CheckRewards(mode, ply)
	if mode == nil and !isnumber(mode) then return end
	if GExtension.Bundle == nil or !isnumber(GExtension.Bundle) or GExtension.Bundle < 0 then return end
	if !#player.GetHumans() then return end

	for k, rewardData in pairs(self.Rewards) do
		local rewardedPly = player.GetBySteamID64(rewardData["steamid64"])

		if IsValid(rewardedPly) then
			local executed_on = GExtension:FromJson(rewardData["executed_on"])
			local expireDate = rewardData["expires_unix"]
			local validRewards = {"ps1_points", "ps2_points", "ps2_premiumpoints", "darkrp_money", "darkrp_levels", "dayz_credits", "dayz_items", "lua", "concommands", "weapons", "reservedslot", "ttt_voicedrain", "ttt_specprop"}
			--weapons_spawn, lua_connect, lua_spawn, console_connect and console_spawn are handled in extra hooks, we don't need to handle it here

			if table.HasValue(validRewards, rewardData["type"]) then
				if mode == 0 and !tobool(rewardData["on_connect"]) and !tobool(rewardData["on_spawn"]) then
					if tobool(rewardData["once"]) then
						--if not executed on this server yet and not already exec. on a server (If one_from_all)
						if !table.HasValue(executed_on, GExtension.ServerID) and (!tobool(rewardData["one_from_all"]) or !tobool(#executed_on)) then
							if tobool(rewardData["on_expire"]) then
							    --the reward should execute after rewardData.expires
								if GExtension:IsExpired(expireDate) then
									GExtension:ExecuteReward(rewardedPly, rewardData, true)
								else
									GExtension:SetExecuted(rewardData)
								end
							else
							    --the reward should execute once now
								GExtension:ExecuteReward(rewardedPly, rewardData)
							end
						end
					else
					    --the reward should be executed until rewardData.expires
						if !GExtension:IsExpired(expireDate) then
							GExtension:ExecuteReward(rewardedPly, rewardData)
						else
							GExtension:SetExecuted(rewardData)
						end
					end
				elseif mode == 1 and tobool(rewardData["on_connect"]) then
					if IsValid(ply) and rewardedPly == ply then
						if tobool(rewardData["once"]) then
							--if not executed on this server yet and not already exec. on a server (If one_from_all)
							if !table.HasValue(executed_on, GExtension.ServerID) and (!rewardData["one_from_all"] or !#executed_on) then
								GExtension:ExecuteReward(rewardedPly, rewardData)
							end
						else
						    --the reward should be executed until rewardData.expires
							if !GExtension:IsExpired(expireDate) then
								GExtension:ExecuteReward(rewardedPly, rewardData)
							else
								GExtension:SetExecuted(rewardData)
							end
						end
					end
				elseif mode == 2 and tobool(rewardData["on_spawn"]) then
					if IsValid(ply) and rewardedPly:SteamID64() == ply:SteamID64() then
						if tobool(rewardData["once"]) then
							--if not executed on this server yet and not already exec. on a server (If one_from_all)
							if !table.HasValue(executed_on, GExtension.ServerID) and (!rewardData["one_from_all"] or !#executed_on) then
								GExtension:ExecuteReward(rewardedPly, rewardData)
							end
						else
						    --the reward should be executed until rewardData.expires
							if !GExtension:IsExpired(expireDate) then
								GExtension:ExecuteReward(rewardedPly, rewardData)
							else
								GExtension:SetExecuted(rewardData)
							end
						end
					end
				end
			end
		end
	end
end

hook.Add("GExtensionInitialized", "GExtension_Rewards_GExtensionInitialized", function()
	GExtension:RefreshRewards()

	timer.Create("GExtensionRewardsTime", GExtension.RewardRefreshTime, 0, function()
		GExtension:RefreshRewards(function()
			GExtension:CheckRewards(0)
		end)
	end)

	hook.Add("GExtensionPlayerInitialized", "GExtension_Rewards_GExtensionPlayerInitialized", function(ply)
		GExtension:CheckRewards(1, ply)
		hook.Call("GExtensionPlayerPostConnectRewards", _, ply)
	end)

	hook.Add("PlayerSpawn", "GExtension_Rewards_Spawn", function(ply)
		if ply:Alive() then
			GExtension:CheckRewards(2, ply)
		end
	end)
end)
