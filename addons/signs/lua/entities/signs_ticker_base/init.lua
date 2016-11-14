
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

util.AddNetworkString( "signs_ticker_edit" )
util.AddNetworkString( "signs_ticker_send_data" )


function ENT:Initialize()
	self:SetModel( self.Model )
	self:SetMaterial( "models/debug/debugwhite" )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetCollisionGroup( COLLISION_GROUP_WEAPON ) -- don't collide with players
	
	self:SetUseType( SIMPLE_USE )
	
	local owner = self:Getowning_ent()

	self.Owned = IsValid( owner )

	if self.Owned then
		self.OwnerSteamID = owner:SteamID()

		if self.CPPISetOwner then
			self:CPPISetOwner( owner )
		end
	end
	
	local phys = self:GetPhysicsObject()

	if IsValid( phys ) then 
		phys:Wake()
	end
end

function ENT:BroadcastData( ply )
	net.Start( "signs_ticker_send_data" )
		net.WriteEntity( self )

		self:WriteData()

	if ply then 
		net.Send( ply )
	else
		net.Broadcast()
	end
end

function ENT:AllowInteraction( ply )
	return ply:IsAdmin() or (self.Owned and ply == self:Getowning_ent())
end

function ENT:Use( ply )
	if !self:AllowInteraction( ply ) then return end

	net.Start( "signs_ticker_edit" )
		net.WriteEntity( self )
	net.Send( ply )
end

function ENT:UpdateTransmitState() -- not ideal, but ensures sign exists when sending data to clients (could also queue it up and check when needed, which would be better)
	return TRANSMIT_ALWAYS
end

function ENT:PhysgunPickup( ply )
	if !Signs.EnableDefaultFPPBehaviors then return end

	return self:AllowInteraction( ply )
end

function ENT:OnPhysgunFreeze( _, _, _, ply )
	if !Signs.EnableDefaultFPPBehaviors then return end

	local interact = self:AllowInteraction( ply )

	if interact then 
		return nil -- return nil to allow freeze (weird)
	else
		return false
	end
end

function ENT:GravGunPickup( ply )
	if !Signs.EnableDefaultFPPBehaviors then return end

	return self:AllowInteraction( ply )
end

function ENT:GravGunPunt( ply )
	if Signs.EnableDefaultFPPBehaviors then 
		return ply:IsAdmin() 
	end
end

function ENT:CanTool( ply ) 
	if Signs.EnableDefaultFPPBehaviors then 
		return ply:IsAdmin() 
	end
end


local playerDataDelays = {}

net.Receive( "signs_ticker_send_data", function( ply, len )
	if playerDataDelays[ply] and (CurTime() - playerDataDelays[ply]) < 1 then return end -- prevents spam

	playerDataDelays[ply] = CurTime()

	local ent = net.ReadEntity()

	if !IsValid( ent ) or ent.Base != "signs_ticker_base" then return end

	if ent:ReadData() then
		ent:BroadcastData()
	end
end )

hook.Add( "PlayerInitialSpawn", "signs_ticker_playerinitialspawn", function( ply )
	timer.Simple( 10, function()
		if !IsValid( ply ) then return end

		for _, ent in pairs( ents.GetAll() ) do
			if ent.Base == "signs_ticker_base" then
				ent:BroadcastData( ply )
			end
		end
	end )
end )
