AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_junk/meathook001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      -- Make us work with physics,
	self:SetMoveType( MOVETYPE_VPHYSICS )   -- after all, gmod is a physics
	self:SetSolid( SOLID_VPHYSICS )         -- Toolbox
	
	self.hooked = false
	self.nexthook = CurTime() + 2
	
        local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
	    phys:Wake()
	end
end

function ENT:Use( ply, caller )
	if !(self.hooked) then return end
	if !(CurTime() > self.nexthook) then return end
	
	self.nexthook = CurTime() + 2
	constraint.RemoveConstraints( self, "Weld" )
	self.hooked = false
end

function ENT:Touch( ent )
	if !(IsValid( ent )) then return end
    self.holder = self.holder or nil
	if !(ent:IsVehicle()) and (self.holder != ent) then return end
	if !(CurTime() > self.nexthook) then return end
	if self.hooked then return end
	
	constraint.Weld(self, ent, 0, 0, 0, 0)
	self.hooked = true
	self.nexthook = CurTime() + 2
	self:EmitSound("/buttons/latchunlocked2.wav", 75, 100)
end