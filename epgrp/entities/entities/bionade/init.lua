AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_glassbottle003a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.CanUse = true
	local phys = self:GetPhysicsObject()

	phys:Wake()
    self.useable = true
end

function ENT:Use( ply )
    if !(self.useable) then return end
    self.useable = false
    ply:SetHealth( math.Clamp(ply:Health() + 10, 0, 100) )
    
    local ent = ents.Create( "empty_bottle" )
    ent:SetPos( self:GetPos() )
    ent:SetAngles( Angle( 0, 0, 0 ) )
    ent:Spawn()
    self:Remove()
end

function ENT:Think()

end