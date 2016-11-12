function SetPlayerScale(ply, scale)
	ply:SetModelScale(scale, 2)

	ply:SetHull(Vector(-16, -16, 0), Vector(16, 16, 64 * scale))
	umsg.Start("rp_playerscale")
		umsg.Entity(ply)
		umsg.Float(scale)
	umsg.End()
end

local function onLoadout(ply)
	--timer.Simple( 2, function() setScale(ply, ply:GetRPVar( "bodysize" ) or 1) end )
end
--hook.Add("PlayerLoadout", "playerScale", onLoadout)