AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	
	--self.wide = self.wide or 250
	--local scale = Vector( self.wide, 5, 5 )
	--self.scale = scale
	
	--local phys = self:GetPhysicsObject()
	--phys:Wake()
	
	--self:SetSSize( scale )
	--for i=0, self:GetBoneCount() do
	--	self:ManipulateBoneScale( i, scale )
	--end

	-- Set up solidity & movetype
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	
	self.think = false
end

function ENT:Use( ply )

end

function ENT:Think()
	if self.think != true then return end
	if self.parent_prop == nil or self.parent_prop == NULL then self:Remove() end
end

function ENT:SetSSize( size )
	--self:SetSolid( SOLID_BBOX )
	--local v = Vector( size, 5, 5 )
	--self:SetCollisionBounds( -v, v )
	--self:SetCollisionBounds( -size, size )
	--self:Activate()
end