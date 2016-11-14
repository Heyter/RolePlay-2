function player.GetBySteamID(ID)
	local PTab = player.GetAll()
	for p=1,#PTab do
		if ID == PTab[p]:SteamID() then
			return PTab[p]
		end
	end
	return false
end

function sendNotify( pl, text, msgtype )
	if SERVER then
		pl:SendLua("notification.AddLegacy( '" .. text .. "', " .. msgtype .. ", 10 ) LocalPlayer():ChatPrint('" .. text .. "')")
	elseif CLIENT then
		notification.AddLegacy(  text , msgtype, 10 )
		LocalPlayer():ChatPrint( text )
	end
end
