AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize( )
	self.Dealer = DRUGDEALER.CurDealer or nil
	
	if self.Dealer == nil then
		self:SetModel( "models/odessa.mdl" )
	else
		self:SetModel( DRUGDEALER.Dealers[DRUGDEALER.CurDealer].model )
	end
	
	self:SetUseType( SIMPLE_USE )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:SetSolid( SOLID_BBOX )
	self:SetMaxYawSpeed( 9999 )
	--self:DropToFloor()

	local bubble = ents.Create( "bubble" )
	bubble:SetParent( self )
	bubble:SetPos( self:GetPos() + Vector(0,0,120) )
	bubble:Spawn( )
end

function ENT:AcceptInput( Name, Activator, Caller )	
    Activator:SendLua( "OpenDDealerPanel()" )
end

function ENT:Think()
	if DRUGDEALER.CurDealer != self.Dealer then
		self:SetModel( DRUGDEALER.Dealers[DRUGDEALER.CurDealer].model )
		self.Dealer = DRUGDEALER.CurDealer
	end
end