AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.AddNetworkString( "orgmenudialogue" )

function ENT:Initialize( )
	self:SetModel( ORGS_Config.npcModel )
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE, CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
	
	if ORGS_Config.npcDrawBubble then
		local bubble = ents.Create("bubble")
		bubble:SetParent( self )
		bubble:SetMoveType( MOVETYPE_NONE )
		bubble:SetSolid(0)
		bubble:SetPos(self:GetPos() + Vector(0,0,90))
		bubble:Spawn()
	end
end

function ENT:OnTakeDamage()
	return false
end 

function ENT:AcceptInput( Name, Activator, Caller )	

	if !Activator.cantUse and Activator:IsPlayer() then
		Activator.cantUse = true
		net.Start( "orgmenudialogue" )
			net.WriteEntity(self)
		net.Send( Activator )
		timer.Simple(1.5, function()
			Activator.cantUse = false
		end)
	end
end