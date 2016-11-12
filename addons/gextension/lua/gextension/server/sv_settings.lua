//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

function GExtension:InitSettings(callback)
	self:Query("SELECT * FROM gex_settings;", _, function(data)
		for k,v in pairs(data) do
			self.Settings[v["setting"]] = v["value"]
		end

		if callback then
			callback()
		end
	end)
end

function GExtension:SetSetting(key, value, callback)
	self:Query("UPDATE gex_settings SET value = %1% WHERE setting = %2%;", {value, key}, function()
		self.Settings[key] = value

		if callback then
			callback()
		end
	end)
end

function GExtension:GetSetting(key)
	if table.HasValue(table.GetKeys(self.Settings), key) then
		return self.Settings[key]
	else
		return ""
	end
end

hook.Add("GExtensionInitialized", "GExtension_Settings_GExtensionInitialized", function()
	timer.Create("GExtension_Settings_Refresh", 300, 0, function()
		GExtension:InitSettings()
	end)
end)