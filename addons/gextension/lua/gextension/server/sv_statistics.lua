//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

hook.Add("GExtensionInitialized", "GExtension_Statistics_GExtensionInitialized", function()
	timer.Create("GExtensionAddTimeForAll", 60, 0, function()
		GExtension:AddTimeForAll()
	end)

	hook.Add("GExtensionPlayerInitialized", "GExtension_Statistics_GExtensionPlayerInitialized", function(ply)
		GExtension:InitStatistics(ply)
		GExtension:Debug("Initialized statistics for player " .. ply:Nick() .. ".")
	end)
end)

function GExtension:InitStatistics(ply, secondtry)
	if IsValid(ply) then
		self:Query("SELECT * FROM gex_statistics WHERE steamid64 = %1% AND serverbundle = %2%", {ply:SteamID64(), self.Bundle}, function(data) 
			if IsValid(ply) then
				if #data > 0 then
					data = data[1]

					if data["time"] and data["time"] != "" then
						data["time"] = self:FromJson(data["time"])
					else
						data["time"] = {}
					end

					self.Statistics[ply:SteamID64()] = data
				else
					self:Query("INSERT INTO gex_statistics (steamid64, time, serverbundle) VALUES(%1%, %2%, %3%)", {ply:SteamID64(), self:ToJson({}), self.Bundle}, function()
						if !secondtry then
							self:InitStatistics(ply, true)
						else
							self:Print("error", "Could not initialize statistics for player " .. ply:Nick() .. ".")
						end
					end)
				end
			end
		end)
	end
end

function GExtension:AddTimeForAll()
	for k,v in pairs(player.GetHumans()) do
		if self.Statistics[v:SteamID64()] then
			self:AddTime(v)
		else
			GExtension:InitStatistics(v)
		end
	end
end

function GExtension:AddTime(ply)
	if IsValid(ply) then
		local time = 0
		local date = os.date("%d-%m-%Y")

		if self.Statistics[ply:SteamID64()]["time"][date] == nil then
			self.Statistics[ply:SteamID64()]["time"][date] = 1
		end

		if self.Statistics[ply:SteamID64()]["time"][date] != nil then
			self.Statistics[ply:SteamID64()]["time"][date] = tonumber(self.Statistics[ply:SteamID64()]["time"][date]) + 1
			self:Query("UPDATE gex_statistics SET time = %1% WHERE id = %2%", {self:ToJson(self.Statistics[ply:SteamID64()]["time"]), self.Statistics[ply:SteamID64()]["id"]})
		end
	end
end