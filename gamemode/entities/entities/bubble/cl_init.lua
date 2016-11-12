include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
	self.Entity:DrawModel()
    if !( IsValid( self ) ) then return true end
	self:SetColor(Color(255,255,255,255))
	self:SetAngles(Angle(0,RealTime() * 50 + 40, 0))
    if !( IsValid( self:GetParent() ) ) then return true end
    self:SetPos( self:GetParent():GetPos() + Vector( 0, 0, 90 + math.sin(CurTime()*3)*2 ) )
end

function ENT:Think()
end
