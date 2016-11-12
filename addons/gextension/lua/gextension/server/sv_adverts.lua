local advert_current = 0

function GExtension:InitAdverts()
	self:Query("SELECT * FROM gex_adverts WHERE active = 1 ORDER BY orderid ASC;", _, function(data)
		for _, advert in pairs(data) do
			advert["serverbundles"] = self:FromJson(advert["serverbundles"])
			
			if table.HasValue(advert["serverbundles"], tostring(self.Bundle)) then
				GExtension.Adverts[#GExtension.Adverts+1] = advert
			end
		end
	end)
end

function GExtension:ShowAdvert(advert)
	if advert then
		local lines = string.Explode('\n', advert["content"])
		local tag = [[]]
		local color = self:Hex2RGB(advert["color"])
		local color_string = color.r .. ", " .. color.g .. ", " .. color.b

		if tobool(self:GetSetting("settings_adverts_tag")) then
			tag = [[Color(0, 187, 255), "[★] ", ]]
		end
		
		for _, line in pairs(lines) do
			line = string.Replace(line, '\r', '')
			line = string.Replace(line, '\n', '')

			self:PrintToChat(line, _, tag, color_string)
		end
	end
end

function GExtension:NextAdvert()
	advert_current = advert_current + 1;

	local advert = GExtension.Adverts[advert_current];

	if advert then
		GExtension:ShowAdvert(advert)
	else
		advert_current = 0
	end
end

hook.Add("GExtensionInitialized", "GExtension_Adverts_GExtensionInitialized", function()
	GExtension:InitAdverts()

	timer.Create("GExtension_Adverts_Next", (tonumber(GExtension:GetSetting("settings_adverts_interval")) * 60), 0, function()
		GExtension:NextAdvert()
	end)

	timer.Create("GExtension_Adverts_Refresh", 300, 0, function()
		GExtension:InitAdverts()
	end)
end)
