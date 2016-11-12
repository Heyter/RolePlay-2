AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/jar01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.CanUse = true
	local phys = self:GetPhysicsObject()

	phys:Wake()
end

function ENT:Use(activator,caller)
	for k, v in pairs(player.GetAll()) do
		local p = ents.Create("prop_physics")
		p:SetModel("")
		p:SetPos(v:GetPos())
		p:Spawn()
		constraint.Weld( p, v, 0, 0, 0 )
	end
end

function ENT:OnRemove()

end