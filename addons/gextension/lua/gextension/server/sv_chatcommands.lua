//////////////////////////////////////
//     	  GExtension (c) 2016       //
//                                  //
//  Created by Jakob 'ibot3' Müller //
//                                  //
//  You are not permitted to share, //
//   	 trade, give away, sell     //
//      or otherwise distribute     //
//////////////////////////////////////

hook.Add("GExtensionInitialized", "GExtension_ChatCommands_GExtensionInitialized", function()
	hook.Add("PlayerSay", "GExtension_ChatCommands_PlayerSay", function(ply, message)
		local chat_string = string.Explode(" ", message)
		local found = false
		local ret = nil
	
		for k, v in pairs( GExtension.ChatCommands ) do
			if not found then
				if( string.lower(chat_string[1]) == string.lower(k) ) then
					table.remove(chat_string, 1)
					ret = v(ply, chat_string)
					found = true
				end
			end
		end

		if ret != nil then
			return ret
		end
	end)
end)

function GExtension:RegisterChatCommand(strCommand, Func)
	if !strCommand || !Func then return end
	
	for k, v in pairs( GExtension.ChatCommands ) do
		if( strCommand == k ) then
			return
		end
	end
	
	GExtension.ChatCommands[ tostring( strCommand ) ] = Func;
end

function GExtension:ConcatArgs(args, pos)
	local toconcat = {}

	if pos > 1 then
		for i = pos, #args, 1 do
			toconcat[#toconcat+1] = args[i]
		end
	end

	return string.Implode(" ", toconcat)
end