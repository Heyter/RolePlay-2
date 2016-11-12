include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
    
    local center = self:OBBMaxs()
    center.x = 0 center.y = 0
    local Pos = self:GetPos() + center*1.6 + Vector( 0, 0, math.sin(CurTime()*5))
    local Ang = LocalPlayer():EyeAngles()

    Ang:RotateAroundAxis( Ang:Forward(), 90 )
    Ang:RotateAroundAxis( Ang:Right(), 90 )

	local font = "RPNormal_40"
	surface.SetFont( font )
	local text = "Zu Verkaufen!"
	local TextWidth = surface.GetTextSize( text )
    
    local text2 = "'Benutzen' zum kaufen"
	local TextWidth2 = surface.GetTextSize( text2 )

	cam.Start3D2D(Pos, Angle( 0, Ang.y, 90 ), 0.1)
		draw.WordBox(2, -TextWidth*0.5, -12, text, font, Color(0, 0, 0, 0), Color(0,200,0,255))
        draw.WordBox(2, -TextWidth2*0.5, 20, text2, font, Color(0, 0, 0, 0), Color(255,255,255,255))
	cam.End3D2D()
end

function ENT:Think()
end