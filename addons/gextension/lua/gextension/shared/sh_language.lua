//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

function GExtension:InitLanguage()
	local files = file.Find("gextension/language/*.lua", "LUA")

	if file.Exists("gextension/language/" .. self.LanguageCode .. ".lua", "LUA") then
		include("gextension/language/" .. self.LanguageCode .. ".lua")
		GExtension:InitLanguageVars()
	else
		if file.Exists("gextension/language/en.lua", "LUA") then
			include("gextension/language/en.lua")
			self:Print("error", "Language file not found, using english now.")
			GExtension:InitLanguageVars()
		else
			self:Print("error", "No language file found!")
		end
	end
end

GExtension:InitLanguage()

function GExtension:Lang(key)
	if GExtension.Language[key] then
		return GExtension.Language[key]
	else
		return "[Error]"
	end
end