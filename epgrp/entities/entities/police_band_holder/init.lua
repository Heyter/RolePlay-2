AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/TrafficCone001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.CanUse = true
	local phys = self:GetPhysicsObject()

	phys:Wake()
    self.useable = true
	
	local ent1 = ents.Create( "prop_physics" )
	ent1:SetPos( self:GetPos() + Vector( -0.2, 0.2, 20) )
	ent1:SetModel( "models/props_canal/mattpipe.mdl" )
	ent1:SetMaterial( "phoenix_storms/metalfloor_2-3" )
	ent1:SetParent( self )
	ent1:Spawn()
	
	local ent2 = ents.Create( "prop_physics" )
	ent2:SetPos( self:GetPos() + Vector( 0.3, 0, 31) )
	ent2:SetModel( "models/props_junk/PopCan01a.mdl" )
	ent2:SetMaterial( "phoenix_storms/metalfloor_2-3" )
	ent2:SetParent( ent1 )
	ent2:Spawn()
	
	self.top_prop = ent2
end

function ENT:Think()
	
end

function ENT:Connect( holder )
	if !(IsValid( holder )) then return end
	local prop = holder.top_prop
	local band = ents.Create( "police_band" )
	local dist = self.top_prop:GetPos():Distance( prop:GetPos() )
	
	band:SetPos( self.top_prop:GetPos() )
	band:SetAngles( (self.top_prop:GetPos() - prop:GetPos()):Angle() )
	band:Spawn()
	--band:GetPhysicsObject():EnableMotion( false )
	
	band:SetPos( self.top_prop:GetPos() - (band:GetForward()*dist/2) )
	band:SetParent( self )
	--self:DeleteOnRemove( band )
	
	band:SetNWInt( "wide", dist )
	--band:SetSSize( dist/2 )
	
	self.band = band
	holder.band = band
	

	band.parent_prop = holder
	band.think = true
end