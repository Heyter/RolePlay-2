//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

util.AddNetworkString("GExtension_Net_GroupData")

function GExtension:InitGroups(callback)
	self:Query("SELECT * FROM gex_groups;", _, function(data)
		self.Groups = {}

		for k, groupData in pairs(data) do
			local groupname = groupData["groupname"]

			self.Groups[groupname] = groupData

			self.Groups[groupname]["permissions"] = self:FromJson(self.Groups[groupname]["permissions"])
			self.Groups[groupname]["settings"] = self:FromJson(self.Groups[groupname]["settings"])
		end

		net.Start("GExtension_Net_GroupData")
			net.WriteTable(GExtension.Groups)
		net.Broadcast()

		if callback then
			callback()
		end
	end)
end

function meta_ply:GE_CheckGroup()
	local group = self:GE_GetGroup()

	if group then
		group = group["groupname"]
		if group != self:GetUserGroup() then
			if serverguard then
				serverguard.player:SetRank(self, group, false, true)
			elseif ulx then
				ULib.ucl.addUser( self:SteamID(), {}, {}, group, true )
			else
				self:SetUserGroup(group)
			end
			
			GExtension:AddToConnectMessage(self, GExtension:FormatString(GExtension:Lang('player_group_updated'), {group}))
			GExtension:Print("success", "Added " .. self:Nick() .. " to group " .. group)
		end
	end
end

function GExtension:GetGroup(steamid64)
	local plydata = self:GetUserData(steamid64)

	if not plydata then return false end
	
	if plydata["groups"]["bundle_" .. self.Bundle] then
		local group = plydata["groups"]["bundle_" .. self.Bundle]

		if self.Groups[group] then
			return self.Groups[group]
		end
	end
	
	return GExtension.Groups[GExtension:GetSetting("settings_general_defaultgroup")]
end

function GExtension:SetGroup(steamid64, groupname, bundle, noapi)
	local bundle = bundle or self.Bundle

	if noapi then
		local plydata = self:GetUserData(steamid64)

		if not plydata then return false end

		plydata["groups"]["bundle_" .. bundle] = groupname

		self:SetUserData(steamid64, "groups", self:ToJson(plydata["groups"]))
	else
		http.Fetch(GExtension.WebURL .. "api.php?t=user&action=setgroup&steamid=" .. steamid64 .. "&bundle=" .. bundle .. "&groupname=" .. groupname .. "&key=" .. self:GetSetting("settings_api_key"), function()
			local ply = player.GetBySteamID64(steamid64)

			if IsValid(ply) then
				GExtension:RefreshPlayer(ply)
			end
		end)
	end
end

function meta_ply:GE_GetGroup()
	return GExtension:GetGroup(self:SteamID64())
end

function meta_ply:GE_CanTarget(steamid64)
	local group = self:GE_GetGroup()
	local group_target = GExtension:GetGroup(steamid64)

	if not group then return false end
	if not group_target then return true end

	if (tonumber(group["level"]) > tonumber(group_target["level"])) or self:GE_HasPermission('super') then
		return true
	else
		return false
	end
end

function meta_ply:GE_Error_Permissions()
	self:GE_PrintToChat(GExtension:Lang("permission_denied"))
end

hook.Add("GExtensionInitialized", "GExtension_Groups_GExtensionInitialized", function()
	hook.Add("GExtensionPlayerInitialized", "GExtension_Groups_GExtensionPlayerInitialized", function(ply)
		net.Start("GExtension_Net_GroupData")
			net.WriteTable(GExtension.Groups)
		net.Send(ply)

		--[[ply:SetNWVarProxy("UserGroup", function(_, _, _, group)
			GExtension:SetGroup(ply:SteamID64(), group)
		end)]]
	end)

	concommand.Add("gex_setgroup", function(ply, _, args)
		if GExtension:IsConsole(ply) then
			local steamid64 = args[1]
			local group = args[2]
			local bundle = args[3]

			if steamid64 and group then
				GExtension:SetGroup(steamid64, group, bundle)
			end
		end
	end, _, FCVAR_SERVER_CAN_EXECUTE)

	if ULib then
		local ulx_adduser = ULib.ucl.addUser
		local ulx_removeuser = ULib.ucl.removeUser

		ULib.ucl.addUser = function(steamid32, allow, deny, groupname, ignoregex)
			if not ignoregex then
				GExtension:SetGroup(util.SteamIDTo64(steamid32), groupname)
			end
			
			ulx_adduser( steamid32, allow, deny, groupname )
		end

		ULib.ucl.removeUser = function(id)
			local steamid64 = nil

			if string.find(id, ":") then
				steamid64 = util.SteamIDTo64(id)
			else
				local ply = player.GetByUniqueID(id)

				if IsValid(ply) then
					steamid64 = ply:SteamID64()
				end
			end

			if steamid64 then
				GExtension:SetGroup(steamid64, GExtension:GetSetting("settings_general_defaultgroup"))
			end
			
			ulx_removeuser( id )
		end
	end

	if serverguard then
		local servergaurd_setrank = serverguard.player["SetRank"]

		function serverguard.player:SetRank(target, rank, bSaveless, ignoregex)
			if not ignoregex then
				if target and not bSaveless then
					if type(target) == "Player" and IsValid(target) then
						GExtension:SetGroup(target:SteamID64(), rank)
					elseif type(target) == "string" and string.match(target, "STEAM_%d:%d:%d+") then
						local steamid = util.SteamIDTo64(target)
						GExtension:SetGroup(steamid, rank)
					end
				end
			end

			servergaurd_setrank(self, target, rank, bSaveless)
		end
	end
end)