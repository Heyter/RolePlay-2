include ("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
    self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local font = "Trebuchet24"
	surface.SetFont( font )
	local text = "$" .. tostring(math.Round((self.dt.value or 0)))
	local TextWidth = surface.GetTextSize( text )

	cam.Start3D2D(Pos + Ang:Up() * 0.9, Ang, 0.1)
		draw.WordBox(2, -TextWidth*0.5, -12, text, font, Color(0, 0, 0, 0), Color(0,200,0,255))
	cam.End3D2D()

	Ang:RotateAroundAxis(Ang:Right(), 180)

	cam.Start3D2D(Pos, Ang, 0.1)
		draw.WordBox(2, -TextWidth*0.5, -12, text, font, Color(0, 0, 0, 0), Color(0,200,0,255))
	cam.End3D2D()
end

function ENT:Think()
end