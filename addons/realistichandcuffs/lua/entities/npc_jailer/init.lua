AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')
function ENT:Initialize()
	self.Entity:SetModel(RHC_JAILER_MODEL)	
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
	
	if activator:IsRHCWhitelisted() then
		net.Start("RHC_Jailer_Menu")
			net.WriteEntity(activator.Dragging)
		net.Send(activator)
	end
end

function ENT:Think()
end