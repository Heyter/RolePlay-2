include("shared.lua")


local tunningPlace;
function ENT:Draw()
    self:DrawModel()
end


hook.Add( "HUDPaint", "DrawtunningPlace", function()
	
	local ent = LocalPlayer():GetEyeTrace().Entity;
	
	if ent != nil and ent != NULL and IsValid(ent) and ent:GetClass() == "ent_tunningplace" then
		tunningPlace = ent;
	else
		tunningPlace = nil;
	end
	if IsValid(tunningPlace) and tunningPlace:GetPos():Distance(LocalPlayer():GetPos()) < 200 then
		local Position = ( tunningPlace:GetPos() + Vector( 0,0,10 ) ):ToScreen();
		draw.DrawText(Sea_cartunning.tunningPlace, "HUDNumber5", Position.x, Position.y, Color( 2, 2, 2, 255 ), 1 )
		draw.DrawText(Sea_cartunning.tunningPlace, "HUDNumber5", Position.x, Position.y-3, Color( 255, 255, 255, 255 ), 1 )
	end
end)