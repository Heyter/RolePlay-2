AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
function ENT:Initialize()
	self.Entity:SetModel(RHC_BAILER_MODEL)	
	self:SetSolid(SOLID_BBOX);
	self:PhysicsInit(SOLID_BBOX);
	self:SetMoveType(MOVETYPE_NONE);
	self:DrawShadow(true);
	self:SetUseType(SIMPLE_USE);
	
	self:SetFlexWeight( 10, 0 )
	self:ResetSequence(3)
end

function ENT:Use( activator, caller )
    if self.Touched and self.Touched > CurTime() then return ; end
	self.Touched = CurTime() + 2;
	
	net.Start("RHC_Bailer_Menu")
	net.Send(activator)
end

function ENT:Think()
end