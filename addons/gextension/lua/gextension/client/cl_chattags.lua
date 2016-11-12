if GExtension.ChatTags then
	hook.Add("OnPlayerChat", "GExtension_ChatTags_OnPlayerChat", function(ply, msg)

		if IsValid(ply) then
			local group = ply:GE_GetGroup()

			if group then
				local teamcolor = team.GetColor(ply:Team())

				chat.AddText(GExtension:Hex2RGB(group["hexcolor"]), "[", group["displayname"], "] ", " ", ply, Color(255,255,255), ": ", msg)

				return true
			end
		end
	end)
end