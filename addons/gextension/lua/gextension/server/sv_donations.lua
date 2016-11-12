//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

function GExtension:InitBoughtPackages(callback)
	self:Query("SELECT *, UNIX_TIMESTAMP(expires) AS expires_unix FROM gex_packages_bought WHERE status = 1;", _, function(data)
		for _, package_bought in pairs(data) do
			if not self.BoughtPackages[package_bought["steamid64"]] then
				self.BoughtPackages[package_bought["steamid64"]] = {}
			end

			self.BoughtPackages[package_bought["steamid64"]][package_bought["donationid"]] = package_bought
		end

		if callback then
			callback()
		end
	end)
end

function GExtension:InitDonations(callback)
	self:Query("SELECT * FROM gex_donations;", _, function(data)
		for _, donation in pairs(data) do
			self.Donations[donation["id"]] = donation
		end

		if callback then
			callback()
		end
	end)
end


hook.Add("GExtensionInitialized", "GExtension_Donations_GExtensionInitialized", function()
	hook.Add("GExtensionPlayerInitialized", "GExtension_Donations_GExtensionPlayerInitialized", function(ply)
		if GExtension.BoughtPackages[ply:SteamID64()] then
			for _, bp in pairs(GExtension.BoughtPackages[ply:SteamID64()]) do
				if (tonumber(bp["expires_unix"]) > GExtension:CurrentTime()) and bp["days"] != 0 then
					GExtension:AddToConnectMessage(ply, GExtension:FormatString(GExtension:Lang("package_expires_days"), {bp["package_name"], math.floor(((tonumber(bp["expires_unix"]) - GExtension:CurrentTime())/60/60/24))}))
				end
			end
		end
	end)

	for _, command in pairs(GExtension.DonateCmds) do
		GExtension:RegisterChatCommand(command, function(ply)
			ply:SendLua([[gui.OpenURL("]] .. GExtension.WebURL .. [[?t=donate")]])
		end)
	end
end)