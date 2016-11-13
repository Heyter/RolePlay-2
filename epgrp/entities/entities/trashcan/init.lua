AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")



function ENT:Initialize()
	self:SetModel("models/props_trainstation/trashcan_indoor001b.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.CanUse = true
	local phys = self:GetPhysicsObject()

	self.trash = {}
	self.maxtrash = 30
	self.owner = self.owner or nil
	phys:Wake()
	
	if self.owner != nil then self.owner:DeleteOnRemove( self ) end
end

function ENT:Use( ply )
	if not (ply:Team() == TEAM_TRASH) then return end
	if table.Count( self.trash ) < 1 then return end
	
	local cnt = table.Count( self.trash )
	self.trash = {}
	
	ply:AddCash( 20*cnt )
end

function ENT:Touch( ent )
	if ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_dynamic" or ent:IsVehicle() or ent:IsPlayer() then return end
	if table.Count( self.trash ) >= self.maxtrash then return end
	
	table.insert( self.trash, ent )
	
	local vPoint = ent:GetPos()
	local effectdata = EffectData()
	effectdata:SetOrigin( vPoint )
	util.Effect( "balloon_pop", effectdata )

	ent:Remove()
end

function ENT:Think()
	return false
end