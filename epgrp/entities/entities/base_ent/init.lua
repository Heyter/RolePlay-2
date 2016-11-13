AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	if self.uname == nil then self:Remove() return end	// Invalid entity
	self:BaseEntity_Load( self.uname )	// Load the basic function from the table
	
	self:SetModel( self.Model )
	self:PhysicsInit(self.PhysicsInit)
	self:SetMoveType(self.SetMoveType)
	self:SetSolid(self.SetSolid)
	
	self:SetColor( self.Color )
	
	self.SizeReward = self.SizeReward or nil		// Police thing
	
	// Move things
	self.wake = self.wake or true
	local phys = self:GetPhysicsObject()
	if !(self.wake) then
		phys:EnableMotion( false)
		phys:Sleep()
	else
		phys:EnableMotion( true )
		phys:Wake()
	end
	
    self.pickup = self.pickup or true
end

function ENT:Touch( ent )
	self.TouchFunction( self, ent )
end

function ENT:OnRemove()
	self.OnRemoveFunction( self )
end

function ENT:OnTakeDamage( dmg )
	self.TakeDamageFunction( self, dmg )
end

function ENT:Use(ply,caller)
	self.UseFunction( self, ply, caller )
end

function ENT:Think()
	self.ThinkFunction( self )
end
