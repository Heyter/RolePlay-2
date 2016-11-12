AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/props_junk/garbage_bag001a.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	self.coprefund = 65
	
	self.canuse = true
	
	local phys = self:GetPhysicsObject()
	phys:Wake()
end

function ENT:OnTakeDamage(dmg)
	self:Remove()
end

function ENT:Use(ply,caller)
	if !self.canuse then return end
	
	if ply:IsSWAT() or ply:IsPolice() then
		ply:AddMoney(self.coprefund)
		ply:RPNotify("Du hast Cocain gefunden und bekommst $" .. self.coprefund .. "!", 5)
		self:Remove()
		return
	end
	
    ply:PickupItem( self )
    self:Remove()
	self.canuse = false
end
