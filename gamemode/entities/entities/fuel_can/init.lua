AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/gascan001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.CanUse = true
	local phys = self:GetPhysicsObject()

	phys:Wake()
end

function ENT:Touch( ent )
    if ent:IsVehicle() then
        local fuel = ent:GetNWInt( "fuel" ) or nil
        if fuel == nil then return end
        
        ent:SetNWInt( "fuel", fuel + 50 )
        self:Remove()
        return true
    end
end

function ENT:Think()

end