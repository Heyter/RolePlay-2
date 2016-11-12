include ("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
end

function ENT:Draw()
    self:DrawModel()
end

function ENT:Think()
end