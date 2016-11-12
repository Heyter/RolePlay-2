//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

function GExtension:Print(type, message)
	if type == "success" then
		MsgC("[GExtension] ", Color(0, 255, 0), message .. "\n")
	elseif type == "error" then
		MsgC("[GExtension] ", Color(255, 0, 0), message .. "\n")
	elseif type == "neutral" then
		MsgC("[GExtension] ", Color(255, 255, 255), message .. "\n")
	end
end

function GExtension:Debug(text)
	if self.DebugMode then
		if text then
			self:Print("neutral", "[DEBUG] " .. text)
		else
			self:Print("error", "[DEBUG] Failed.")
		end
	end
end