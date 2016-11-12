include('shared.lua')
 
--[[---------------------------------------------------------
   Name: Draw
   Purpose: Draw the model in-game.
   Remember, the things you render first will be underneath!
---------------------------------------------------------]]
function ENT:Draw()
    -- self.BaseClass.Draw(self)  -- We want to override rendering, so don't call baseclass.
                                  -- Use this when you need to add to the rendering.
    self:DrawModel()       -- Draw the model.
 
end

function BlitzerFlash()
	local alpha = 255
	hook.Add("HUDPaint", "RP_BlitzerFlash", function()
		alpha = Lerp(0.05, alpha, 0)
		surface.SetDrawColor(255,255,255,alpha)
		surface.DrawRect(0,0,ScrW(), ScrH())

		if math.Round(alpha) == 0 then
			hook.Remove("HUDPaint", "RP_BlitzerFlash")
		end
	end)
end

hook.Add("HUDPaint", "RP_BlitzerInfo", function()

	local trace = LocalPlayer():GetEyeTrace()
	local ent = trace.Entity
    if !(IsValid( ent )) then return end
    
	if ent:GetClass() == "ent_blitzer" and LocalPlayer():GetPos():Distance(ent:GetPos()) < 80 and (LocalPlayer():IsPolice() or LocalPlayer():IsSWAT()) then
		local ScreenPos = (ent:GetPos() + Vector(0,0,50)):ToScreen()
		surface.SetFont("RPNormal_25")
		local textl = surface.GetTextSize("Tippe /speedlimit <geschwindigkeit> ein um die Geschwindigkeit einzustellen!")
		local time = math.Round( (ent:GetRPVar( "remove_time" ) or 0) - CurTime() )
        print( ent:GetRPVar( "remove_time" ) )
        local text = "Noch " .. time .. " Sekunden Aktiv"
        surface.SetFont( "RPNormal_25" )
        local w, h = surface.GetTextSize( text )
        draw.SimpleText( text, "RPNormal_25", ScreenPos.x - w/2, ScreenPos.y - 150, Color( 255, 255, 255, 255 ) )
        draw.SimpleTextOutlined("Speedlimit: " .. (ent:GetRPVar( "speed_limit" ) or "Unbekannt") .. " Km/h", "RPNormal_25", ScreenPos.x, ScreenPos.y - 50, Color(255,255,255,200), 1, 0, 3, Color(60,60,60,255))
		draw.SimpleTextOutlined("Tippe /speedlimit <geschwindigkeit> ein um die Geschwindigkeit einzustellen!", "RPNormal_25", ScreenPos.x, ScreenPos.y, Color(255,255,255,200), 1, 0, 3, Color(60,60,60,255))
	end
end)
