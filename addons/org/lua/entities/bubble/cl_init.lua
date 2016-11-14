include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self.Entity:DrawModel()
	self:SetColor(Color(255,255,255,255))
	self:SetAngles(Angle(0,RealTime() * 200 + 40, 0))
end

function ENT:Think()
end
