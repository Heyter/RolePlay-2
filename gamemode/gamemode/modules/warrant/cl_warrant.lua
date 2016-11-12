local meta = FindMetaTable( "Player" )
local starlevel = {}

hook.Add( "HUDPaint", "DrawWarrantStars", function()

	for i=1, SETTINGS.MAX_STARS or 5 do
		local star = Material("roleplay/hud/warrant_star.png")
		surface.SetMaterial(star)
		surface.SetDrawColor(0, 0, 0, 50)
		surface.DrawTexturedRect(ScrW() - (79*math.Clamp( i, 0, 100 )), 15, 64, 64)
	end
	
	if LocalPlayer():GetRPVar( "warrant" ) == nil then
		return
	end
	
	if LocalPlayer():GetRPVar( "warrant" ) == 0 and #starlevel > 0 then table.Empty( starlevel ) end
	
	if LocalPlayer():GetRPVar( "warrant" ) != 0 and LocalPlayer():GetRPVar( "warrant" ) > #starlevel then
		local r = LocalPlayer():GetRPVar( "warrant" ) - #starlevel
		for i=1, r do
			table.insert( starlevel, {time=5, lastdraw=CurTime() + 1} )
		end
	elseif LocalPlayer():GetRPVar( "warrant" ) != 0 and LocalPlayer():GetRPVar( "warrant" ) < #starlevel then
		local r = #starlevel - LocalPlayer():GetRPVar( "warrant" )
		for i=1, r do
			table.remove( starlevel, #starlevel )
		end
	end
	
	for k, v in pairs( starlevel ) do
		local rech = math.Clamp( v.lastdraw - CurTime() , -1, 1 )
		if v.time > 0 && rech == -1 then
			v.lastdraw = CurTime() + 1
			v.time = v.time - 1
			if v.time < 0 then v.time = 0 end
			rech = math.Clamp( v.lastdraw - CurTime() , -1, 1 )
		end
		if v.time > 0 && rech > 0 then
			local star = Material("roleplay/hud/warrant_star.png")
			surface.SetMaterial(star)
			surface.SetDrawColor(255, 255, 255, 200)
			surface.DrawTexturedRect(ScrW() - (79*math.Clamp( k, 0, 100 )), 15, 64, 64)
		elseif v.time == 0 then
			local star = Material("roleplay/hud/warrant_star.png")
			surface.SetMaterial(star)
			surface.SetDrawColor(255, 255, 255, 200)
			surface.DrawTexturedRect(ScrW() - (79*math.Clamp( k, 0, 100 )), 15, 64, 64)
		end
	end
end)